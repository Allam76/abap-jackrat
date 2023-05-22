CLASS and_or_tests DEFINITION FOR TESTING RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    methods test_and_insensitive FOR TESTING.
    methods test_and FOR TESTING.
ENDCLASS.

CLASS and_or_tests IMPLEMENTATION.
  METHOD test_and.
    data(scanner) = new zcl_jackrat_scanner( 'hello world' ).
    data(helloParser) = new ZCL_JACKRAT_ATOM_PARSER( name = 'hello' atom = 'hello'  CASE_INSENSITIVE = abap_false ).
    data(worldParser) = new ZCL_JACKRAT_ATOM_PARSER( name = 'world' atom = 'world'  CASE_INSENSITIVE = abap_false ).
    data(helloAndWorldParser) = new ZCL_JACKRAT_And_Parser( name = 'helloAndWorld' CHILDREN = value #( ( helloParser ) ( worldParser ) ) ).
    data(node) = helloAndWorldParser->parse( scanner ).
    if node->parser ne helloAndWorldParser.
      cl_abap_unit_assert=>fail( 'And combinator creates node with wrong parser' ).
    endif.
    if node->matched ne 'helloworld'.
      cl_abap_unit_assert=>fail( |And combinator doesn't match complete input| ).
    endif.
  ENDMETHOD.
  METHOD test_and_insensitive.
    data(scanner) = new zcl_jackrat_scanner( 'HELLO world' ).
    data(helloParser) = new ZCL_JACKRAT_ATOM_PARSER( name = 'hello' atom = 'Hello'  CASE_INSENSITIVE = abap_true ).
    data(worldParser) = new ZCL_JACKRAT_ATOM_PARSER( name = 'world' atom = 'world'  CASE_INSENSITIVE = abap_true ).
    data(helloAndWorldParser) = new ZCL_JACKRAT_And_Parser( name = 'helloAndWorld' CHILDREN = value #( ( helloParser ) ( worldParser ) ) ).
    data(node) = helloAndWorldParser->parse( scanner ).
    if node->parser ne helloAndWorldParser.
      cl_abap_unit_assert=>fail( 'And combinator creates node with wrong parser' ).
    endif.
    if node->matched ne 'HELLOworld'.
      cl_abap_unit_assert=>fail( |And combinator doesn't match complete input| ).
    endif.
  ENDMETHOD.
ENDCLASS.
