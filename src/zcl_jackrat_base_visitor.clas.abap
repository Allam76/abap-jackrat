class zcl_jackrat_base_visitor definition
  public
  create public.

  public section.
    types data_tab_type type table of ref to data with empty key.
    types: begin of name_value_type,
             name  type string,
             value type string,
           end of name_value_type,
           name_value_type_tab type table of name_value_type with key name.
    types: begin of node_type,
             type     type string,
             text     type string,
             data     type ref to data,
             children type data_tab_type,
           end of node_type,
           node_type_tab type table of node_type with empty key.

    methods visit importing context type ref to zcl_jackrat_node returning value(result) type ref to zcl_jackrat_node raising zcx_open_sql_rest_parser.
    methods visit_children importing context type ref to zcl_jackrat_node returning value(result) type ref to zcl_jackrat_node.
    methods visit_terminal importing context type ref to zcl_jackrat_node returning value(result) type ref to zcl_jackrat_node.
  protected section.
  private section.
ENDCLASS.



CLASS ZCL_JACKRAT_BASE_VISITOR IMPLEMENTATION.


  method visit.
    result = context.
    "result->children = value zcl_jackrat_node=>nodes_tab( for child in result->children ( child->accept( me ) ) ).
  endmethod.


  method visit_children.
  endmethod.


  method visit_terminal.
  endmethod.
ENDCLASS.
