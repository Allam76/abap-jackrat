class regex_tests definition for testing risk level harmless.
  public section.
    methods test_regex for testing.
    methods test_regex_pattern for testing.
    methods test_irregular_regex for testing.
endclass.

class regex_tests implementation.
  method test_regex.
    data(scanner) = new zcl_jackrat_scanner( '-3.4' ).
    data(numparser) = new zcl_jackrat_regex_parser( name = 'num' rs = '-?\d+\.\d+' case_insensitive = abap_true ).
    data(node) = numparser->parse( scanner ).
    if node->parser ne numparser.
      cl_abap_unit_assert=>fail( 'And combinator creates node with wrong parser' ).
    endif.
  endmethod.

  method test_regex_pattern.
    data(scanner) = new zcl_jackrat_scanner( '2' ).
    data(numparser) = new zcl_jackrat_regex_parser( name = 'num' rs = '[0-9]' case_insensitive = abap_true ).
    data(node) = numparser->parse( scanner ).
    if node->parser ne numparser.
      cl_abap_unit_assert=>fail( 'And combinator creates node with wrong parser' ).
    endif.
  endmethod.

  method test_irregular_regex.
  endmethod.
endclass.
