class zcl_jackrat_rule_parser definition inheriting from zcl_jackrat_children_parser
  public
  create public .

  public section.
    methods constructor importing name type string optional node_func type string optional child type ref to zcl_jackrat_parser optional .
    methods match redefinition.
  protected section.
  private section.
endclass.



class zcl_jackrat_rule_parser implementation.
  method constructor.
    super->constructor( name = name node_func = node_func ).
    if child is not initial.
      children = value #( ( child ) ).
    endif.
    type = 'RuleParser'.
  endmethod.
  method match.
    result = s->apply_rule( children[ 1 ] ).
  endmethod.
endclass.
