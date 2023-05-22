class zcl_jackrat_children_parser definition
  public
  inheriting from zcl_jackrat_parser
  create public .

  public section.
    data children type zcl_jackrat_parser=>parser_tab.
    methods constructor importing name      type string
                                  children  type zcl_jackrat_parser=>parser_tab optional
                                  node_func type string.
  protected section.
  private section.
endclass.



class zcl_jackrat_children_parser implementation.
  method constructor.
    super->constructor( name = name node_transform = node_func ).
    me->type = 'ChildParser'.
    me->children = children.
  endmethod.
endclass.
