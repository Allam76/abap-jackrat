class zcl_jackrat_parser definition
  public
  create public .

  public section.
    types parser_tab type table of ref to zcl_jackrat_parser with empty key.
    "types parser_node_type_tab type table of parser_node_type with empty key.
    data type type string value 'base'.
    data node_transform type string.
    data type_name type string.
    data name type string.
    methods constructor importing name type string node_transform type string optional.
    methods match importing s type ref to zcl_jackrat_scanner returning value(result) type ref to zcl_jackrat_node.
    methods parse importing original_scanner type ref to zcl_jackrat_scanner returning value(result) type ref to zcl_jackrat_node raising zcx_jackrat_parser_exception.
    methods parse_partial importing original_scanner type ref to zcl_jackrat_scanner returning value(result) type ref to zcl_jackrat_node raising zcx_jackrat_parser_exception.
    methods transform importing node type ref to zcl_jackrat_node returning value(result) type ref to zcl_jackrat_node.
    class-methods last_index_of importing text type string pattern type string returning value(result) type i.
    methods get_return importing type          type string
                                 matched       type string
                                 data          type ref to data optional
                                 parser        type ref to zcl_jackrat_parser
                                 children      type zcl_jackrat_node=>nodes_tab optional
                       returning value(result) type ref to zcl_jackrat_node.
    methods run_jsonata importing text type string node type ref to zcl_jackrat_node returning value(result) type ref to data.
  protected section.
  private section.
endclass.



class zcl_jackrat_parser implementation.
  method match.
  endmethod.

  method last_index_of.
    data(matches) =  cl_abap_matcher=>create( text = text pattern = pattern )->find_all(  ).
    result = matches[ lines( matches ) ]-offset.
  endmethod.
  method constructor.
    type = 'BaseParser'.
    me->name = name.
    if name is initial.
      me->name = me->type.
    endif.
    me->node_transform = node_transform.
  endmethod.

  method parse.
    data(node) = original_scanner->apply_rule( me ).
    if node is not initial.
      node = node->map_transforms( ).
      if original_scanner->position < strlen( original_scanner->input ).
        data(consumed) = substring( val = original_scanner->input off = original_scanner->position ).
        data(line) = count( val = consumed regex = '\n' ) + 1.
        data(match_last) = find( val = consumed sub = '\n' occ = -1 ).
        data(last_index) = cond i( when match_last = -1 then 0 else match_last ).
        data(column) = original_scanner->position - last_index + 1.
        raise exception type zcx_jackrat_parser_exception
          exporting
            parser   = me
            line     = line
            column   = column
            position = original_scanner->position
            text     = original_scanner->input.
      endif.
      result = node.
      return.
    endif.

    data(max_pos) = 0.
    data failed_parsers type zcl_jackrat_parser=>parser_tab.
    data(index) = strlen( original_scanner->input ).
    while index >= 0.
      if not line_exists( original_scanner->memoization[ index = index ] ) or original_scanner->memoization[ 1 ]-data is initial.
        index = index - 1.
        continue.
      endif.
      max_pos = index.
      append lines of value zcl_jackrat_parser=>parser_tab( for wa in original_scanner->memoization[ 1 ]-data ( wa-parser ) ) to failed_parsers.
      if not failed_parsers is initial.
        exit.
      endif.
      index = index - 1.
    endwhile.
    if max_pos >= strlen( original_scanner->input ).
      max_pos = strlen( original_scanner->input ) - 1.
    endif.
    data(consmd) = substring( val = original_scanner->input off = 0 len = max_pos ).
    data(lin) = count( val = consmd regex = '\n' ) + 1.
    if not consumed is initial.
      data(last_break) = cond #( when last_index_of( text = consumed pattern = '\n' ) >= 0 then last_index_of( text = consumed pattern = '\n' ) else 0 ).
    else.
      last_break = 0.
    endif.
    data(col) = max_pos - last_break + 1.

    raise exception type zcx_jackrat_parser_exception exporting parser = me line = lin column = col position = original_scanner->position text = original_scanner->input.
  endmethod.

  method parse_partial.
    result = original_scanner->apply_rule( me )->map_transforms( ).
  endmethod.
  method transform.
  endmethod.

  method get_return.
    if node_transform is not initial.
      split node_transform at '--' into data(class_name) data(method_name).
      call method (class_name)=>(method_name)
        exporting
          node   = new zcl_jackrat_node( type = name matched = matched parser = me children = children )
        receiving
          result = result.
    else.
      result = new zcl_jackrat_node( type = name matched = matched parser = me children = children ).
    endif.
  endmethod.
  method run_jsonata.
    result = zcl_pratt_parser=>execute( source = text input = ref #( node ) ).
  endmethod.
endclass.
