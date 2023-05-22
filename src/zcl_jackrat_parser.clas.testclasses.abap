class left_recursion_tests definition for testing risk level harmless.
  public section.
    methods test_left_recursion for testing.
endclass.

class left_recursion_tests implementation.
  method test_left_recursion.
    data(scanner) = new zcl_jackrat_scanner( '5-1-4-3' ).
    data(empty_parser) = new zcl_jackrat_empty_parser( name = 'empty' ).
    data(empty_parser1) = new zcl_jackrat_and_parser( name = 'and' children = value #( ( empty_parser ) ) ).

    data(num_parser) = new zcl_jackrat_regex_parser( name = 'regex' rs = '\d+' ).
    data(num_combo1) = new zcl_jackrat_and_parser( name = 'combo1' children = value #( ( empty_parser1 ) ( empty_parser1 ) ( num_parser ) ) ).
    data(minus_parser) = new zcl_jackrat_atom_parser( name = 'minus' atom = '-' ).

    data(term_parser) = new zcl_jackrat_and_parser( name = 'term' children = value #( ) ).
    data(expr_parser) = new zcl_jackrat_or_parser( name = 'or' children = value #( ( term_parser ) ( num_combo1 ) ) ).
    term_parser->children = value #( ( expr_parser ) ( minus_parser ) ( num_combo1 ) ).
    try.
        data(node) = expr_parser->parse( scanner ).
      catch zcx_jackrat_parser_exception into data(err).
        cl_abap_unit_assert=>fail( msg = err->get_text( ) ).
    endtry.
    cl_abap_unit_assert=>assert_equals( act = node->parser exp = expr_parser msg = 'should have right parser' ).
  endmethod.
endclass.

class json_tests definition for testing risk level harmless.
  public section.
    methods test_json for testing.
    methods test_identifier for testing.
    methods test_string for testing.
    methods test_bool for testing.
    methods test_number for testing.
endclass.

class json_tests implementation.
  method test_json.
    data(input) = '{"menu": { ' &&
'"header": "Test", ' &&
'"items": [ ' &&
'  {"id": "1"}, ' &&
'  {"id": "2", "label": "Open New"}, ' &&
'  null, ' &&
'  {"id": "a", "label": "In"}, ' &&
'  {"id": "b", "label": "Out"}, ' &&
'  {"id": "3", "label": "Original 4"}, ' &&
'  null, ' &&
'  {"id": "5"}, ' &&
'  {"id": "6"}, ' &&
'  {"id": "7", "value": 3.451}, ' &&
'  null, ' &&
'  null, ' &&
'  {"id": "8", "boolean": false}, ' &&
'  {"id": "9", "label": "About..."} ' &&
'] ' &&
'}} '.
    condense input no-gaps.
    data(scanner) = new zcl_jackrat_scanner( '{"aa":"aa"}' ).
    data(string_parser) = new zcl_jackrat_and_parser( name = 'string' children = value #(
        ( new zcl_jackrat_atom_parser( atom = '"' ) )
        ( new zcl_jackrat_regex_parser( name = 'identifier' rs = '(?:[^"\\]|\\.)*' ) )
        ( new zcl_jackrat_atom_parser( '"' ) )
      ) ).
    data(value_parser) = new zcl_jackrat_or_parser( name = 'value' children = value #( ) ).
    data(prop_parser) = new zcl_jackrat_and_parser( name = 'propItem' children = value #(
      ( string_parser ) ( new zcl_jackrat_atom_parser( ':' ) ) ( value_parser ) )
    ).
    data(obj_parser) = new zcl_jackrat_and_parser( name = 'object' children = value #(
      ( new zcl_jackrat_atom_parser( '{' ) )
      ( new zcl_jackrat_kleene_parser( name = 'property' sub_parser = prop_parser sep_parser = new zcl_jackrat_atom_parser( ',' ) ) )
      ( new zcl_jackrat_atom_parser( '}' ) )
    ) ).
    data(null_parser) = new zcl_jackrat_atom_parser( 'null' ).
    data(num_parser) = new zcl_jackrat_regex_parser( name = 'number' rs = '-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?' ).
    data(bool_parser) = new zcl_jackrat_regex_parser( name = 'trueFalse' rs = '(true|false)' ).
    data(array_parser) = new zcl_jackrat_and_parser( name = 'array' children = value #(
      ( new zcl_jackrat_atom_parser( '\[' ) )
      ( new zcl_jackrat_kleene_parser( name = 'arrayItem' sub_parser = value_parser ) )
      ( new zcl_jackrat_atom_parser( ',' ) )
      ( new zcl_jackrat_atom_parser( '\]' ) )
    ) ).
    value_parser->children = value #( ( null_parser ) ( obj_parser ) ( string_parser ) ( num_parser ) ( bool_parser ) ( array_parser ) ).
    data(node) = value_parser->parse( scanner ).
    cl_abap_unit_assert=>assert_not_initial( act = node msg = 'should not be initial'  ).
  endmethod.

  method test_identifier.
    data(scanner) = new zcl_jackrat_scanner( 'hello' ).
    data(identifier_parser) = new zcl_jackrat_regex_parser( name = 'identifier' rs = '(?:[^"\\]|\\.)*' ).
    data(node) = identifier_parser->parse( scanner ).
    cl_abap_unit_assert=>assert_not_initial( act = node msg = 'should not be initial'  ).
    cl_abap_unit_assert=>assert_equals( act = node->matched exp = 'hello' msg = 'should be equal' ).
  endmethod.
  method test_string.
    data(scanner) = new zcl_jackrat_scanner( '"hello"' ).
    data(parser) = new zcl_jackrat_and_parser( name = 'string' children = value #(
      ( new zcl_jackrat_atom_parser( atom = '"' ) )
      ( new zcl_jackrat_regex_parser( name = 'identifier' rs = '(?:[^"\\]|\\.)*' ) )
      ( new zcl_jackrat_atom_parser( atom = '"' ) )
    ) ).
    data(node) = parser->parse( scanner ).
    cl_abap_unit_assert=>assert_not_initial( act = node msg = 'should not be initial'  ).
    cl_abap_unit_assert=>assert_equals( act = node->matched exp = '"hello"' msg = 'should be equal' ).
  endmethod.
  method test_bool.
    data(scanner) = new zcl_jackrat_scanner( 'true' ).
    data(parser) = new zcl_jackrat_regex_parser( name = 'bool' rs = '(true|false)' ).
    data(node) = parser->parse( scanner ).
    cl_abap_unit_assert=>assert_not_initial( act = node msg = 'should not be initial'  ).
    cl_abap_unit_assert=>assert_equals( act = node->matched exp = 'true' msg = 'should be equal' ).
  endmethod.
  method test_number.
    data(scanner) = new zcl_jackrat_scanner( '55' ).
    data(parser) = new zcl_jackrat_regex_parser( name = 'number' rs = '-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?' ).
    data(node) = parser->parse( scanner ).
    cl_abap_unit_assert=>assert_not_initial( act = node msg = 'should not be initial'  ).
    cl_abap_unit_assert=>assert_equals( act = node->matched exp = '55' msg = 'should be equal' ).
  endmethod.
endclass.
