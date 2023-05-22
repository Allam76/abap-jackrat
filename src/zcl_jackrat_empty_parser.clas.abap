class zcl_jackrat_empty_parser definition
  public
  inheriting from zcl_jackrat_parser
  create public .

  public section.

    methods constructor
      importing
        !name           type string
        !node_transform type string optional .

    methods match
        redefinition .
  protected section.
  private section.
endclass.



class zcl_jackrat_empty_parser implementation.


  method constructor.
    super->constructor( name = name node_transform = node_transform ).
    me->type = 'EmptyParser'.
  endmethod.


  method match.
    result = get_return( type = name matched = '' parser = me ).
  endmethod.
endclass.
