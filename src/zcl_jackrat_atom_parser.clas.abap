class zcl_jackrat_atom_parser definition
  public
  inheriting from zcl_jackrat_regex_parser
  create public .

  public section.
    methods constructor importing name             type string optional
                                  atom             type string
                                  case_insensitive type abap_bool default abap_false
                                  skip_ws          type abap_bool default abap_true
                                  node_func        type string optional.
  protected section.
  private section.
endclass.



class zcl_jackrat_atom_parser implementation.
  method constructor.
    super->constructor( name = name rs = '\Q' && atom && '\E' case_insensitive = case_insensitive skip_whitespace = skip_ws node_transform = node_func ).
    me->type = 'AtomParser'.
    me->name = cond #( when name is initial then 'atom' else name ).
  endmethod.
endclass.
