class maybe_tests definition for testing risk level harmless.
  public section.
    methods maybe_test for testing.
    methods maybe_irregular_test for testing.
    methods nested_maybes for testing.
    methods maybe_and for testing.
endclass.

class maybe_tests implementation.
  method maybe_test.
    data(scanner) = new zcl_jackrat_scanner( 'Hello' ).
    data(hello_parser) = new zcl_jackrat_atom_parser( name = 'hello' atom = 'Hello'  case_insensitive = abap_false ).
    data(hello_maybe_parser) = new zcl_jackrat_maybe_parser( name = 'helloMaybe' sub_parser = hello_parser ).
    data(node) = hello_maybe_parser->parse( scanner ).
    cl_abap_unit_assert=>assert_equals( act = node->parser exp = hello_maybe_parser msg = 'should be right parser' ).
    cl_abap_unit_assert=>assert_equals( act = lines( node->children )  exp = 1 msg = 'should have children count of 1' ).
  endmethod.
  method maybe_irregular_test.
    data(hello_parser) = new zcl_jackrat_atom_parser( name = 'hello' atom = 'Hello'  case_insensitive = abap_false ).
    data(irregular_scanner) = new zcl_jackrat_scanner( 'Sonne' ).
    data(irregular_parser) = new zcl_jackrat_maybe_parser( name = 'irregular' sub_parser = hello_parser ).
    data(node) = irregular_parser->parse_partial( irregular_scanner ).
    cl_abap_unit_assert=>assert_not_initial( act = node msg = 'node should be bound' ).
    cl_abap_unit_assert=>assert_equals( act = node->parser exp = irregular_parser msg = 'should be right parser' ).
    cl_abap_unit_assert=>assert_equals( act = lines( node->children )  exp = 0 msg = 'should have children count of 0' ).
  endmethod.

  method nested_maybes.
    data(scanner) = new zcl_jackrat_scanner( 'hello.world' ).
    data(any_name) = new zcl_jackrat_regex_parser( name = 'name' rs = '[a-z][A-Za-z]*' ).
    data(dot) = new zcl_jackrat_atom_parser( name = 'dot' atom = '.' ).
    data(database_table_column) = new zcl_jackrat_and_parser( name = 'database_table_column' children = value #(
      ( new zcl_jackrat_maybe_parser( name = `` sub_parser = new zcl_jackrat_and_parser( name = '' children = value #(
        ( new zcl_jackrat_maybe_parser( name = `` sub_parser = new zcl_jackrat_and_parser( name = '' children = value #(
          ( any_name )
          ( dot )
        ) ) ) )
        ( any_name )
        ( dot )
      ) ) ) )
      ( any_name )
    ) ).
    data(node) = database_table_column->parse( scanner ).
    cl_abap_unit_assert=>assert_not_initial( act = node msg = 'node should be bound' ).
    cl_abap_unit_assert=>assert_equals( act = node->parser exp = database_table_column msg = 'should be right parser' ).
  endmethod.

  method maybe_and.
    data(scanner) = new zcl_jackrat_scanner( 'hello.world' ).
    data(any_name) = new zcl_jackrat_regex_parser( name = 'name' rs = '[a-z][A-Za-z]*' ).
    data(dot) = new zcl_jackrat_atom_parser( name = 'dot' atom = '.' ).
    data(database_table_column) = new zcl_jackrat_and_parser( name = 'database_table_column' children = value #(
      ( new zcl_jackrat_maybe_parser( name = `` sub_parser = new zcl_jackrat_and_parser( name = '' children = value #(
        ( any_name )
        ( dot )
      ) ) ) )
      ( any_name )
    ) ).
    data(node) = database_table_column->parse( scanner ).
    cl_abap_unit_assert=>assert_not_initial( act = node msg = 'node should be bound' ).
    cl_abap_unit_assert=>assert_equals( act = node->parser exp = database_table_column msg = 'should be right parser' ).
  endmethod.
endclass.
