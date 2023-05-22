class zcl_jackrat_node definition
  public inheriting from cl_sxml_reader
  create public.

  public section.
    interfaces: if_serializable_object.
    types nodes_tab type table of ref to zcl_jackrat_node with default key.

    data type type string.
    data matched type string.
    data parser type ref to zcl_jackrat_parser.
    data children type nodes_tab.
    data data type ref to data.
    data ast_node type ref to object.
    data parent type ref to zcl_jackrat_node.

    methods constructor importing type     type string
                                  matched  type string
                                  data     type ref to data optional
                                  parser   type ref to zcl_jackrat_parser
                                  children type nodes_tab optional.

    methods find_parser_type importing type_name type string returning value(result) type ref to zcl_jackrat_node.
    methods find_child_parser_type importing type_name type string returning value(result) type ref to zcl_jackrat_node.
    methods map_transforms importing type_name type string optional returning value(result) type ref to zcl_jackrat_node.
    methods accept importing visitor type ref to zcl_jackrat_base_visitor returning value(result) type ref to zcl_jackrat_node.
    methods clone returning value(result) type ref to zcl_jackrat_node.
    methods filter_children_by_type importing type type string returning value(result) type nodes_tab.
    methods reduce returning value(result) type ref to zcl_jackrat_node.
    methods get_xml returning value(result) type string.
    methods save_to_mime importing url type string input type string.
    methods get_child_by_name importing name type string returning value(result) type ref to zcl_jackrat_node.
  protected section.
  private section.
endclass.



class zcl_jackrat_node implementation.


  method accept.
    result = visitor->visit( me ).
  endmethod.


  method clone.
    result = new #( type = me->type matched = me->matched data = me->data parser = me->parser ).
    " call transformation id source instance = me result xml data(xml_data).
    " call transformation id source xml xml_data result instance = result.
  endmethod.


  method constructor.
    super->constructor(  ).
    me->type = type.
    me->matched = matched.
    me->parser = parser.
    me->children = children.
    me->data = data.
  endmethod.


  method filter_children_by_type.
    loop at children assigning field-symbol(<child>) where table_line->type = type.
      append <child> to result.
    endloop.
  endmethod.


  method find_child_parser_type.
    loop at children into data(child).
      data(sub) = child->find_parser_type( type_name ).
      if sub is not initial.
        result = sub.
        return.
      endif.
    endloop.
  endmethod.


  method find_parser_type.
    result = cond #( when parser->type_name = type_name then me else find_child_parser_type( type_name ) ).
  endmethod.


  method get_xml.
    call transformation id source instance = me result xml result.
  endmethod.


  method map_transforms.
    loop at children into data(n).
      n->parent = me.
      n->map_transforms( ).
    endloop.
    result = me.
  endmethod.


  method reduce.
    data children type nodes_tab.
    data child type ref to zcl_jackrat_node.

    loop at me->children into child.
      data(out_child) = child->reduce( ).
      if out_child is bound.
        append out_child to children.
      endif.
    endloop.
    case type of me->parser.
      when type zcl_jackrat_or_parser into data(or_parser).
        if line_exists( children[ 1 ] ).
          result = children[ 1 ].
          return.
        else.
          return.
        endif.
      when type zcl_jackrat_maybe_parser into data(maybe_parser).
        if line_exists( children[ 1 ] ).
          result = children[ 1 ].
          return.
        else.
          clear result.
        endif.
        return.
      when type zcl_jackrat_kleene_parser into data(kleene_parser).
        if lines( me->children ) = 0.
          clear result.
          return.
        elseif kleene_parser->sep_parser is bound.
          loop at children into child.
            if match( val = child->matched regex = cast zcl_jackrat_regex_parser( kleene_parser->sep_parser )->rs ) <> ''.
              delete children index sy-tabix.
            endif.
          endloop.
        endif.
      when type zcl_jackrat_many_parser into data(many_parser).
        loop at children into child.
          if not child is initial and not many_parser is initial and not many_parser->sep_parser is initial.
            if match( val = child->matched regex = cast zcl_jackrat_regex_parser( many_parser->sep_parser )->rs ) <> ''.
              delete children index sy-tabix.
            endif.
          endif.
        endloop.
      when type zcl_jackrat_atom_parser.
        if me->type is not initial and me->type ne 'atom'.
        else.
          return.
        endif.
      when type zcl_jackrat_and_parser.
        if lines( children ) = 0.
          return.
        endif.
      when others.
    endcase.
    result = me->clone( ).
    result->children = children.
  endmethod.


  method save_to_mime.
    data(api) = cl_mime_repository_api=>get_api(  ).
    cl_abap_conv_out_ce=>create( encoding = 'UTF-8' )->convert( exporting data = input importing buffer = data(xstr) ).
    api->put( i_url = url i_content = xstr i_dev_package = '$TMP' i_description = 'test xxml data' i_suppress_dialogs = abap_true i_suppress_package_dialog = abap_true ).
  endmethod.

  method get_child_by_name.
    loop at children assigning field-symbol(<child>).
      if <child>->type = name.
        result = <child>.
      endif.
    endloop.
  endmethod.
endclass.
