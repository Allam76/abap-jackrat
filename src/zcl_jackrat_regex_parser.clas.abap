class zcl_jackrat_regex_parser definition
  public inheriting from zcl_jackrat_parser
  create public .

  public section.
    data rs type string.
    data case_insensitive type abap_bool value abap_false.
    data skip_whitespace type abap_bool value abap_true.
    data regex type string.

    methods constructor importing name             type string
                                  rs               type string
                                  case_insensitive type abap_bool default abap_false
                                  skip_whitespace  type abap_bool default abap_true
                                  node_transform   type string optional.
    methods match redefinition.
  protected section.
  private section.
endclass.



class zcl_jackrat_regex_parser implementation.
  method constructor.
    super->constructor( name = name node_transform = node_transform ).
    type = 'RegexParser'.
    me->rs = rs.
    me->case_insensitive = case_insensitive.
    me->skip_whitespace = skip_whitespace.
    me->node_transform = node_transform.
    me->regex = '^' && rs.
    me->name = cond #( when name is initial then 'regex' else name ).
  endmethod.

  method match.
    data(start_position) = s->position.
    if skip_whitespace = abap_true.
      s->skip_white_space( ).
      " if s->is_at_break( ) = abap_false.
      "     s->position = start_position.
      "     return.
      " endif.
    endif.

    data(matched) = s->match_text( regex = regex case_insensitive = case_insensitive ).
    if matched is initial.
      s->position = start_position.
      return.
    endif.

    if skip_whitespace = abap_true.
      s->skip_white_space( ).
      " if s->is_at_break( ) = abap_false.
      "     s->position = start_position.
      "     return.
      " endif.
    endif.

    result = get_return( type = name matched = matched parser = me ).
  endmethod.
endclass.
