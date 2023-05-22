class empty_tests definition for testing risk level harmless.
  public section.
    methods test_empty for testing.
    methods test_double_empty for testing.
endclass.

class empty_tests implementation.
  method test_empty.
    data(scanner) = new zcl_jackrat_scanner( 'Hello' ).
    data(emptyParser) = new zcl_jackrat_empty_parser( name = 'empty' ).
    data(helloparser) = new zcl_jackrat_atom_parser( name = 'hello' atom = 'hello'  case_insensitive = abap_true ).
    data(emptyandhelloparser) = new zcl_jackrat_and_parser( name = 'emptyandhello' children = value #( ( emptyParser ) ( helloparser ) ) ).
    data(node) = emptyandhelloparser->parse( scanner ).
    if node->parser ne emptyandhelloparser.
      cl_abap_unit_assert=>fail( 'combinator creates node with wrong parser' ).
    endif.
    cl_abap_unit_assert=>assert_equals( act = node->matched exp = 'Hello' msg = 'matched text should be ok' ).

    cl_abap_unit_assert=>assert_equals( act = lines( node->children ) exp = 2 msg = |Empty Test combinator child count doesn't match| ).
    if node->children[ 1 ]->parser ne emptyParser or node->children[ 2 ]->parser ne helloParser.
      cl_abap_unit_assert=>fail( |Empty Test combinator children do not match| ).
    endif.
  endmethod.

  method test_double_empty.
    data(scanner) = new zcl_jackrat_scanner( '' ).
    data(emptyParser) = new zcl_jackrat_empty_parser( name = 'empty' ).
    data(termparser) = new zcl_jackrat_and_parser( name = 'term' children = value #( ( emptyParser ) ( emptyParser ) ) ).
    data(node) = termparser->parse( scanner ).
    if node->parser ne termparser.
      cl_abap_unit_assert=>fail( 'Double empty parser creates node with wrong parser' ).
    endif.
  endmethod.
endclass.
