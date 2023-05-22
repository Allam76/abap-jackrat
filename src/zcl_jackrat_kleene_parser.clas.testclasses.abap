CLASS kleene_tests DEFINITION FOR TESTING RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    methods kleene_test FOR TESTING.
    methods kleene_irregular_test FOR TESTING.
    methods kleene_separator_test FOR TESTING.
    methods kleene_empty_test FOR TESTING.
ENDCLASS.

CLASS kleene_tests IMPLEMENTATION.
  METHOD kleene_test.
    data(scanner) = new zcl_jackrat_scanner( 'Hello Hello Hello' ).
    data(hello_parser) = new ZCL_JACKRAT_ATOM_PARSER( name = 'hello' atom = 'hello'  CASE_INSENSITIVE = abap_false ).
    data(hello_kleene_parser) = new ZCL_JACKRAT_KLEENE_PARSER( name = 'helloKleene' sub_parser = hello_parser ).
    data(node) = hello_kleene_parser->parse( scanner ).
    cl_abap_unit_assert=>assert_equals( act = node->parser exp = hello_kleene_parser msg = 'And combinator creates node with wrong parser' ).
    cl_abap_unit_assert=>assert_equals( act = lines( node->children ) exp = 3 msg = 'children count should be the same' ).
  ENDMETHOD.
  METHOD kleene_irregular_test.
    data(hello_parser) = new ZCL_JACKRAT_ATOM_PARSER( name = 'hello' atom = 'Hello'  CASE_INSENSITIVE = abap_true ).
    data(irregular_scanner) = new zcl_jackrat_scanner( 'Sonne' ).
    data(irregular_parser) = new zcl_jackrat_kleene_parser( name = 'kleene' sub_parser = hello_parser ).
    data(irregular_node) = irregular_parser->parse_partial( irregular_scanner ).
    cl_abap_unit_assert=>assert_not_initial( act = irregular_node msg = 'should not be null' ).
    cl_abap_unit_assert=>assert_equals( act = irregular_parser exp = irregular_node->parser msg = 'Irregular kleene parser creates node with wrong parser' ).
    cl_abap_unit_assert=>assert_equals( act = 0 exp = lines( irregular_node->children ) msg = 'Irregular kleene parser doesnt produce zero children for irregular input' ).
  ENDMETHOD.

  METHOD kleene_separator_test.
    data(scanner) = new zcl_jackrat_scanner( 'Hello, Hello, Hello' ).
    data(hello_parser) = new ZCL_JACKRAT_ATOM_PARSER( name = 'hello' atom = 'Hello'  CASE_INSENSITIVE = abap_false ).
    data(sep_parser) = new ZCL_JACKRAT_ATOM_PARSER( name = 'sep' atom = ','  CASE_INSENSITIVE = abap_false ).
    data(hello_kleene_parser) = new ZCL_JACKRAT_KLEENE_PARSER( name = 'helloKleene' sub_parser = hello_parser SEP_PARSER = sep_parser ).
    data(node) = hello_kleene_parser->parse( scanner ).
    cl_abap_unit_assert=>assert_not_initial( act = node msg = 'should not be null' ).
    cl_abap_unit_assert=>assert_equals( act = node->matched exp = 'Hello,Hello,Hello' msg = 'matched should match' ).
    cl_abap_unit_assert=>assert_equals( act = lines( node->children ) exp = 5 msg = 'children count should be the same' ).
  ENDMETHOD.
  METHOD kleene_empty_test.
    data(scanner) = new zcl_jackrat_scanner( '' ).
    data(hello_parser) = new ZCL_JACKRAT_ATOM_PARSER( name = 'hello' atom = 'Hello'  CASE_INSENSITIVE = abap_false ).
    data(hello_kleene_parser) = new ZCL_JACKRAT_KLEENE_PARSER( name = 'helloKleene' sub_parser = hello_parser ).
    data(node) = hello_kleene_parser->parse( scanner ).
    cl_abap_unit_assert=>assert_not_initial( act = node msg = 'should not be null' ).
    cl_abap_unit_assert=>assert_equals( act = node->matched exp = '' msg = 'matched should match' ).
    cl_abap_unit_assert=>assert_equals( act = lines( node->children ) exp = 0 msg = 'children count should be the same' ).
  ENDMETHOD.
ENDCLASS.
