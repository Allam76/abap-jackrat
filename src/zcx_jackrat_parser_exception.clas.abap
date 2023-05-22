class ZCX_JACKRAT_PARSER_EXCEPTION definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  interfaces IF_T100_DYN_MSG .
  interfaces IF_T100_MESSAGE .
  data parser type ref to zcl_jackrat_parser.
  data line type i.
  data column type i.
  data position type i.
  data val type ref to object.
  data text type string.
  methods constructor importing parser type ref to zcl_jackrat_parser line type i column type i position type i val type ref to object optional text type string.
  methods get_text redefinition.
protected section.
private section.
ENDCLASS.



class zcx_jackrat_parser_exception implementation.


  method constructor ##adt_suppress_generation.
    call method super->constructor.
    clear me->textid.
    me->parser = parser.
    me->line = line.
    me->column = column.
    me->position = position.
    me->val = val.
    me->text = text.
  endmethod.

  method get_text.
    result = |Error in line: { line } column: { column } pos: { position } input: { text } Parser: { parser->name }|.
  endmethod.
endclass.
