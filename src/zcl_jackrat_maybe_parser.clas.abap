class zcl_jackrat_maybe_parser definition
  public
  inheriting from zcl_jackrat_children_parser
  create public .

  public section.

    data sub_parser type ref to zcl_jackrat_parser .

    methods constructor
      importing
        !name           type string
        !sub_parser     type ref to zcl_jackrat_parser
        !node_transform type string optional.

    methods match
        redefinition .
  protected section.
  private section.
endclass.



class zcl_jackrat_maybe_parser implementation.


  method constructor.
    super->constructor( name = name children = value #( ( sub_parser ) ) node_func = node_transform ).
    me->sub_parser = sub_parser.
    me->type = 'MaybeParser'.
  endmethod.


  method match.
    data(start_position) = s->position.
    data(node) = s->apply_rule( sub_parser ).
    if node is initial.
      s->position = start_position.
      result = get_return( matched = '' type = name parser = me ).
      return.
    endif.
    result = get_return( type = name matched = node->matched parser = me children = value #( ( node ) ) ).
  endmethod.
endclass.
