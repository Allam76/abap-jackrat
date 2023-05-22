class zcl_jackrat_name_parser definition inheriting from zcl_jackrat_children_parser
  public
  create public .

  public section.
    methods constructor importing name type string optional node_func type string optional child type ref to zcl_jackrat_parser optional .
    methods match redefinition.
  protected section.
  private section.
endclass.



class zcl_jackrat_name_parser implementation.
  method constructor.
    super->constructor( name = name node_func = node_func children = value #( ( child ) ) ).
    type = 'NameParser'.
  endmethod.
  method match.
    data(node) = s->apply_rule( children[ 1 ] ).
    if node is not initial.
      result = node.
    endif.
  endmethod.
endclass.
