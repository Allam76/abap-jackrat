class zcl_jackrat_many_parser definition
  public
  inheriting from zcl_jackrat_children_parser
  create public .

  public section.

    data sub_parser type ref to zcl_jackrat_parser .
    data sep_parser type ref to zcl_jackrat_parser .
    data add_sep type boolean.

    methods constructor
      importing
        !name           type string
        !add_sep        type boolean default abap_false
        !sub_parser     type ref to zcl_jackrat_parser optional
        !sep_parser     type ref to zcl_jackrat_parser optional
        !node_transform type string optional.

    methods match
        redefinition .
  protected section.
  private section.
endclass.



class zcl_jackrat_many_parser implementation.


  method constructor.
    super->constructor( name = name node_func = node_transform ).
    type = 'ManyParser'.
    me->sub_parser = sub_parser.
    me->sep_parser = sep_parser.
    me->add_sep = add_sep.

    if sub_parser is not initial and sep_parser is not initial.
      children = value #( ( sub_parser ) ( sep_parser ) ).
    elseif sub_parser is not initial.
      children = value #( ( sub_parser ) ).
    else.
      children = value #( ).
    endif.
  endmethod.


  method match.
    data(i) = 0.
    data(last_valid_pos) = s->position.
    data nodes type zcl_jackrat_node=>nodes_tab.

    do.
      data(matchedsep) = abap_false.
      data sepnode type ref to zcl_jackrat_node.

      if i > 0 and sep_parser is not initial.
        sepnode = s->apply_rule( sep_parser ).
        if sepnode is initial.
          exit.
        endif.
        matchedsep = abap_true.
      endif.
      i = i + 1.

      data(node) = s->apply_rule( sub_parser ).
      if node is initial.
        exit.
      endif.
      if matchedsep = abap_true and add_sep = abap_true.
        append sepnode to nodes.
      endif.

      append node to nodes.
      last_valid_pos = s->position.
    enddo.
    s->position = last_valid_pos.

    if lines( nodes ) >= 1.
      data(matched) = reduce string( init acc type string for it in nodes next acc = acc && it->matched ).
      result = get_return( type = name matched = matched parser = me children = nodes ).
    endif.
  endmethod.
endclass.
