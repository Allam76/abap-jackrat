class zcl_jackrat_kleene_parser definition
  public
  inheriting from zcl_jackrat_children_parser
  create public .

  public section.

    data sub_parser type ref to zcl_jackrat_parser .
    data sep_parser type ref to zcl_jackrat_parser .

    methods constructor
      importing
        !name       type string
        !sub_parser type ref to zcl_jackrat_parser
        !sep_parser type ref to zcl_jackrat_parser optional
        !node_func  type string optional .

    methods match
        redefinition .
  protected section.
  private section.
endclass.



class zcl_jackrat_kleene_parser implementation.


  method constructor.
    super->constructor( name = name node_func = node_func ).
    me->sub_parser = sub_parser.
    me->sep_parser = sep_parser.
    me->type = 'KleeneParser'.
    if sep_parser is not initial.
      me->children = value #( ( sub_parser ) ( sep_parser ) ).
    elseif sub_parser is not initial.
      me->children = value #( ( sub_parser ) ).
    endif.
  endmethod.


  method match.
    data nodes type zcl_jackrat_node=>nodes_tab.
    data(i) = 0.
    data(last_valid_position) = s->position.

    do.
      data(matched_sep) = abap_false.
      data sep_node type ref to zcl_jackrat_node.
      if i > 0 and sep_parser is not initial.
        sep_node = s->apply_rule( sep_parser ).
        if sep_node is initial.
          exit.
        endif.
        matched_sep = abap_true.
      endif.
      i = i + 1.

      data(node) = s->apply_rule( sub_parser ).
      if node is initial.
        exit.
      endif.
      if matched_sep is not initial.
        append sep_node to nodes.
      endif.
      append node to nodes.
      last_valid_position = s->position.
    enddo.
    s->position = last_valid_position.

    data(matched) = reduce string( init acc type string for it in nodes next acc = acc && it->matched ).
    result = get_return( type = name matched = matched parser = me children = nodes ).
  endmethod.
endclass.
