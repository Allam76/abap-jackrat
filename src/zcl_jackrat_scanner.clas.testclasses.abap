class scanner_test definition for testing risk level harmless.
  public section.
    methods test_simple for testing.
endclass.

class scanner_test implementation.
  method test_simple.
    data(scanner) = new ZCL_JACKRAT_SCANNER( 'HELLO world' ).
    data(hello_parser) = new zcl_jackrat_atom_parser( name = 'hello' atom = 'HELLO' skip_ws = abap_true ).
    data(world_parser) = new zcl_jackrat_atom_parser( name = 'world' atom = 'world' skip_ws = abap_true ).
    data(hello_and_world_parser) = new zcl_jackrat_and_parser( name = 'hello_and_world' children = value #( ( hello_parser ) ( world_parser ) ) ).
    data(node) = hello_and_world_parser->parse( scanner ).

    cl_abap_unit_assert=>ASSERT_EQUALS( act = node->type exp = 'hello_and_world' msg = 'should have correct type' ).
    cl_abap_unit_assert=>ASSERT_EQUALS( act = node->CHILDREN[ 1 ]->TYPE exp = 'hello' msg = 'should have correct type' ).
    cl_abap_unit_assert=>ASSERT_EQUALS( act = node->CHILDREN[ 2 ]->TYPE exp = 'world' msg = 'should have correct type' ).

    cl_abap_unit_assert=>ASSERT_EQUALS( act = node->MATCHED exp = 'HELLOworld' msg = 'should have correct value' ).
    cl_abap_unit_assert=>ASSERT_EQUALS( act = node->CHILDREN[ 1 ]->MATCHED exp = 'HELLO' msg = 'should have correct value' ).
    cl_abap_unit_assert=>ASSERT_EQUALS( act = node->CHILDREN[ 2 ]->MATCHED exp = 'world' msg = 'should have correct value' ).
  endmethod.
endclass.
