class end_tests definition for testing risk level harmless.
  public section.
    methods test_end for testing.
endclass.

class end_tests implementation.
  method test_end.
    data(scanner) = new zcl_jackrat_scanner( 'Hello' ).
    data(endParser) = new zcl_jackrat_end_parser( name = 'end' SKIP_WHITESPACE = abap_false ).
    data(helloparser) = new zcl_jackrat_atom_parser( name = 'hello' atom = 'hello' ).
    data(helloEndParser) = new zcl_jackrat_and_parser( name = 'helloEnd' children = value #( ( helloparser ) ( endParser ) ) ).
    data(node) = helloEndParser->parse( scanner ).
    if node->parser ne helloEndParser.
      cl_abap_unit_assert=>fail( 'combinator creates node with wrong parser' ).
    endif.
    cl_abap_unit_assert=>assert_equals( act = node->matched exp = 'Hello' msg = 'matched text should be ok' ).
    cl_abap_unit_assert=>assert_equals( act = lines( node->children ) exp = 2 msg = |Empty Test combinator child count doesn't match| ).
  endmethod.
endclass.
