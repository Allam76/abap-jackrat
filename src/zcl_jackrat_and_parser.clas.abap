class zcl_jackrat_and_parser definition
  public
  inheriting from zcl_jackrat_children_parser
  create public .

  public section.
    methods constructor importing name      type string
                                  children  type zcl_jackrat_parser=>parser_tab
                                  node_func type string optional.
    methods match redefinition.
  protected section.
  private section.
endclass.



class zcl_jackrat_and_parser implementation.
  method constructor.
    super->constructor( name = name children = children node_func = node_func ).
    type = 'AndParser'.
  endmethod.

  method match.
    data nodes type zcl_jackrat_node=>nodes_tab.
    data(start_position) = s->position.

    loop at children into data(it).
      data(node) = s->apply_rule( it ).
      if node is initial.
        s->position = start_position.
        return.
      endif.
      append node to nodes.
    endloop.
    data(matched) = reduce string( init acc type string for n in nodes next acc = acc && n->matched ).
    if node_transform is not initial.
      split node_transform at '-' into data(class_name) data(method_name).
      call method (class_name)=>(method_name)
        exporting
          node   = new zcl_jackrat_node( type = name matched = matched parser = me children = nodes )
        receiving
          result = result.
    else.
      result = get_return( type = name matched = matched parser = me children = nodes ).
    endif.
  endmethod.
endclass.
