class zcl_jackrat_action_parser definition inheriting from zcl_jackrat_children_parser
public
create public .

  public section.
    data action type string.
    methods constructor importing name      type string optional
                                  node_func type string optional
                                  action    type string
                                  child     type ref to zcl_jackrat_parser optional .
    methods match redefinition.
  protected section.
  private section.
endclass.



class zcl_jackrat_action_parser implementation.
  method constructor.
    super->constructor( name = name node_func = node_func children = value #( ( child ) ) ).
    type = 'ActionParser'.
    me->action = action.
  endmethod.
  method match.
    data(node) = s->apply_rule( children[ 1 ] ).
    if action is not initial.
      "data(context) = build_context(  ).
      node->data = run_jsonata( text = action node = node ).
    else.
      result = node.
    endif.
  endmethod.
endclass.
