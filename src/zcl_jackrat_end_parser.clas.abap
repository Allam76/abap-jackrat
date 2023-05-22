class zcl_jackrat_end_parser definition
  public
  inheriting from zcl_jackrat_parser
  create public .

  public section.

    methods constructor importing name            type string
                                  node_transform  type string optional
                                  skip_whitespace type abap_bool default abap_true.

    methods match
        redefinition .
  protected section.
  private section.
    data skip_whitespace type abap_bool.
endclass.



class zcl_jackrat_end_parser implementation.


  method constructor.
    super->constructor( name = name node_transform = node_transform ).
    me->skip_whitespace = skip_whitespace.
    me->type = 'EndParser'.
  endmethod.


  method match.
    data(start_position) = s->position.
    if skip_whitespace = abap_true.
      s->skip_white_space( ).
    endif.

    if s->position = strlen( s->input ).
      result = get_return( type = name matched = '' parser = me ).
      return.
    endif.

    s->position = start_position.
  endmethod.
endclass.
