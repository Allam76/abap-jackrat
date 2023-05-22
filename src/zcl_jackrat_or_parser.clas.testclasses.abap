CLASS or_tests DEFINITION FOR TESTING RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    methods test_and_insensitive FOR TESTING.
ENDCLASS.

CLASS or_tests IMPLEMENTATION.
  METHOD test_and_insensitive.
    data(scanner) = new zcl_jackrat_scanner( 'World' ).
    data(helloParser) = new ZCL_JACKRAT_ATOM_PARSER( name = 'hello' atom = 'HELLO'  CASE_INSENSITIVE = abap_true ).
    data(worldParser) = new ZCL_JACKRAT_ATOM_PARSER( name = 'world' atom = 'world'  CASE_INSENSITIVE = abap_true ).
    data(helloOrWorldParser) = new ZCL_JACKRAT_Or_Parser( name = 'helloOrWorld' CHILDREN = value #( ( helloParser ) ( worldParser ) ) ).
    data(node) = helloOrWorldParser->parse( scanner ).
    if node->parser ne helloOrWorldParser.
      cl_abap_unit_assert=>fail( 'And combinator creates node with wrong parser' ).
    endif.
    cl_abap_unit_assert=>ASSERT_EQUALS( act = lines( node->CHILDREN ) exp = 1 msg = 'count should be 1' ).
  ENDMETHOD.
ENDCLASS.
