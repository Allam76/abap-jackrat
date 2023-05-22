class zcl_jackrat_or_parser definition
  public
  inheriting from zcl_jackrat_children_parser
  create public .

  public section.

    methods constructor
      importing
        !name      type string optional
        !children  type zcl_jackrat_parser=>parser_tab
        !node_func type string optional .

    methods match
        redefinition .
  protected section.
  private section.
endclass.



class zcl_jackrat_or_parser implementation.


  method constructor.
    super->constructor( name = name children = children node_func = node_func ).
    type = 'OrParser'.
  endmethod.


  method match.
    data(start_position) = s->position.
    loop at children into data(it).
      data(node) = s->apply_rule( it ).
      if node is not initial.
        result = get_return( type = name matched = node->matched parser = me children = value #( ( node ) ) ).
        return.
      endif.
      s->position = start_position.
    endloop.
  endmethod.
endclass.
