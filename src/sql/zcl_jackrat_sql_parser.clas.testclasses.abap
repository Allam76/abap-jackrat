class test_simple DEFINITION FOR TESTING RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    METHODS test_select FOR TESTING.
ENDCLASS.

class test_simple IMPLEMENTATION.
  METHOD TEST_SELECT.
    data(identifier) = new ZCL_JACKRAT_REGEX_PARSER( name = 'identifier' rs = '[a-zA-Z0-9_$]+' ).
    data(comma_sep) = new zcl_jackrat_atom_parser( name = 'commasep' atom = ',' ).
    data(target_list) = new zcl_jackrat_many_parser( name = 'targetList' sub_parser = identifier sep_parser = comma_sep ).
    data(select_stat) = new ZCL_JACKRAT_AND_PARSER( name = 'select' CHILDREN = value #(
      ( new ZCL_JACKRAT_ATOM_PARSER( 'SELECT' ) )
      ( target_list )
      ( new ZCL_JACKRAT_ATOM_PARSER( 'FROM' ) )
      ( identifier )
    ) ).
    data(scanner) = new ZCL_JACKRAT_SCANNER( 'select test, name from tabl' ).
    data(node) = select_stat->parse( scanner ).
    cl_abap_unit_assert=>assert_not_initial( act = node msg = 'node should not be empty' ).
    cl_abap_unit_assert=>assert_equals( act = node->matched exp = 'selecttest,namefromtabl' msg = 'text should match' ).
  ENDMETHOD.
ENDCLASS.
