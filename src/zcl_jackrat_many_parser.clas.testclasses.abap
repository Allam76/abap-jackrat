CLASS many_tests DEFINITION FOR TESTING RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    methods many_tests FOR TESTING.
    methods many_separator_test FOR TESTING.
    methods many_separator_regex_test for testing.
    methods many_no_kleene_test for testing.
ENDCLASS.

CLASS many_tests IMPLEMENTATION.
  METHOD many_tests.
    data(scanner) = new zcl_jackrat_scanner( 'Hello Hello Hello' ).
    data(hello_parser) = new zcl_jackrat_atom_parser( name = 'hello' atom = 'hello'  CASE_INSENSITIVE = abap_false ).
    data(hello_many_parser) = new zcl_jackrat_many_parser( name = 'helloMany' sub_parser = hello_parser ).
    data(node) = hello_many_parser->parse( scanner ).
    CL_ABAP_UNIT_ASSERT=>ASSERT_EQUALS( act = node->PARSER exp = hello_many_parser msg = 'should be right parser' ).
    CL_ABAP_UNIT_ASSERT=>ASSERT_EQUALS( act = lines( node->CHILDREN )  exp = 3 msg = 'should have children count of 3' ).
  ENDMETHOD.
  METHOD many_separator_test.
    data(scanner) = new zcl_jackrat_scanner( 'Hello, Hello, Hello' ).
    data(hello_parser) = new zcl_jackrat_atom_parser( name = 'hello' atom = 'hello'  CASE_INSENSITIVE = abap_false ).
    data(sep_parser) = new zcl_jackrat_atom_parser( name = 'commasep' atom = ','  CASE_INSENSITIVE = abap_false ).
    data(hello_many_parser) = new zcl_jackrat_many_parser( name = 'helloMany' sub_parser = hello_parser sep_parser = sep_parser ).
    data(node) = hello_many_parser->parse( scanner ).
    cl_abap_unit_assert=>assert_equals( act = node->parser exp = hello_many_parser msg = 'should be right parser' ).
    cl_abap_unit_assert=>assert_equals( act = node->matched exp = 'Hello,Hello,Hello' msg = 'should have right matched value' ).
    cl_abap_unit_assert=>assert_equals( act = lines( node->children )  exp = 5 msg = 'should have children count of 5' ).
  ENDMETHOD.

  method many_separator_regex_test.
  endmethod.

  method many_no_kleene_test.
  endmethod.
ENDCLASS.
