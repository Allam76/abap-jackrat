class ZCL_JACKRAT_SCANNER definition
  public
  create public .

public section.

types: begin of data_set_type,
          key type ref to zcl_jackrat_parser,
          flag type abap_bool,
          end of data_set_type,
          data_set_type_tab type table of data_set_type with empty key.

types: begin of head_type,
    rule type ref to zcl_jackrat_parser,
    involved_set type data_set_type_tab,
    eval_set type data_set_type_tab,
    end of head_type.

types: begin of head_index_type,
         index type i,
         head type head_type,
         end of head_index_type,
         head_tab_type type table of head_index_type with key index.

types: begin of lr_type,
    seed type ref to zcl_jackrat_node,
    rule type ref to zcl_jackrat_parser,
    head type head_type,
    next type ref to data,
    end of lr_type.

types: begin of memo_entry_type,
    lr type ref to lr_type,
    ans type ref to zcl_jackrat_node,
    position type i,
    end of memo_entry_type,
    memo_entry_type_tab type table of memo_entry_type with empty key.

types: begin of parser_memo_entry_type,
       parser type ref to zcl_jackrat_parser,
       memo_entry type memo_entry_type,
       end of parser_memo_entry_type,
       parser_memo_entry_type_tab type table of parser_memo_entry_type with empty key.

types: begin of memoizer_type,
        index type i,
        data type parser_memo_entry_type_tab,
        end of memoizer_type,
       memoizer_type_tab type standard table of memoizer_type with key index.

types memoizer_typ_tab type table of parser_memo_entry_type_tab with empty key.

types: begin of parser_bool_type,
   parser type ref to zcl_jackrat_parser,
   bool type abap_bool,
   end of parser_bool_type,
   parser_bool_type_tab type table of parser_bool_type with empty key.

data input type string.
data position type i.
data memoization type memoizer_type_tab.
data heads type head_tab_type.
data skip_regex type string.
data breaks type table of i.
  methods constructor importing input type string
                              position type i default 0
                              skip_whitespace type abap_bool default abap_true.
  methods skip_white_space.
  methods is_at_break returning value(result) type abap_bool.
  methods match_text importing regex type string case_insensitive type abap_bool default abap_true returning value(result) type string.
  methods apply_rule importing rule type ref to zcl_jackrat_parser returning value(result) type ref to zcl_jackrat_node.
  methods recall importing rule type ref to zcl_jackrat_parser pos type i returning value(result) type memo_entry_type.
  methods lr_answer importing rule type ref to zcl_jackrat_parser pos type i changing m type memo_entry_type returning value(result) type ref to zcl_jackrat_node.
  methods setup_lr importing rule type ref to zcl_jackrat_parser changing l type ref to lr_type.
  methods grow_lr importing rule type ref to zcl_jackrat_parser p type i changing m type memo_entry_type h type head_type RETURNING VALUE(result) type ref to zcl_jackrat_node.
protected section.
private section.
data skip_whitespace type abap_bool.
data invocation_stack type ref to lr_type.

class-methods get_breaks importing input type string RETURNING VALUE(result) type INT_TAB1.

ENDCLASS.



CLASS ZCL_JACKRAT_SCANNER IMPLEMENTATION.
  method constructor.
    me->input = input.
    me->position = position.
    me->skip_whitespace = skip_whitespace.
    if skip_whitespace = abap_true.
      me->skip_regex = '^[\r\n\t ]+'.
    endif.
    breaks = get_breaks( input ).
  endmethod.

  method get_breaks.
    find ALL OCCURRENCES OF REGEX '[^\w\d_$.]' in input results data(occs).
    data(non_readable) = value int_tab1( for occ in occs ( occ-offset ) ).
    data(previous_word) = abap_false.
    data(inx) = 0.
    while inx <= strlen( input ).
      data(current_word) = cond abap_bool( when line_exists( non_readable[ table_line = inx ] ) then abap_false else abap_true ).
      if current_word = abap_false or previous_word = abap_false.
        append inx to result.
      endif.
      previous_word = current_word.
      inx = inx + 1.
    endwhile.
    append strlen( input ) to result.
  endmethod.

  method recall.
    data m type memo_entry_type.
    data mmap type parser_memo_entry_type_tab.
    mmap = memoization[ index = pos ]-data.
    if mmap is not initial and line_exists( mmap[ parser = rule ] ).
     m = mmap[ parser = rule ]-memo_entry.
    endif.
    data head type head_type.
    if line_exists( heads[ index = pos ] ).
      head = heads[ index = pos ]-head.
    else.
      result = m.
      return.
    endif.

    " Do not evaluate any rule that is not involved in this left recursion
    if m is initial and not line_exists( head-involved_set[ key = rule ] ).
        result = value memo_entry_type(  position = position ).
        return.
    endif.

    if line_exists( head-eval_set[ key = rule ] ).
        delete head-eval_set where key = rule.
        data(res) = rule->match( me ).
        result = value memo_entry_type( ans = res position = position ).
        return.
    endif.

    result = m.
  endmethod.

  method lr_answer.
    data(h) = m-lr->head.
    if h-rule ne rule.
      result = m-lr->seed.
      return.
    endif.
    m-ans = m-lr->seed.
    clear m-lr.
    if m-ans is initial.
      return.
    endif.
    result = grow_lr( exporting rule = rule p = pos changing m = m h = h ).
  endmethod.

  method setup_lr.
    if l->head is initial.
      l->head = value head_type( rule = rule ).
    endif.
    data(stack) = invocation_stack.
    data(temp_inx) = 0.
    while stack is not initial and stack->head ne l->head.
        stack->head = l->head.
        data new_involved type parser_bool_type_tab.
        loop at l->head-involved_set into data(it).
          new_involved[ parser = it-key ]-bool = abap_true.
        endloop.
        append value #( parser = stack->rule bool = abap_true ) to new_involved.
        l->head-involved_set = new_involved.
        stack = cast lr_type( stack->next ).
        if TEMP_INX > 100.
          exit.
        endif.
        TEMP_INX = TEMP_INX + 1.
    endwhile.
  endmethod.

  method grow_lr.
    if line_exists( heads[ index = p ] ).
      heads[ index = p ]-head = h.
    else.
      append value #( index = p head = h ) to heads.
    endif.
    do.
      position = p.
      loop at h-involved_set into data(it).
        if line_exists( h-eval_set[ key = it-key ] ).
          h-eval_set[ key = it-key ]-flag = it-flag.
        else.
          append value #( key = it-key flag = it-flag ) to h-eval_set.
        endif.

      endloop.
      data(res) = rule->match( me ).
        if res is initial or position le m-position.
          exit.
        endif.
        clear m-lr.
        m-ans = res.
        m-position = position.
    enddo.
    delete heads where index = p.
    position = m-position.
    result = m-ans.
  endmethod.

  method match_text.
    data matched type string.
    try.
      if case_insensitive = abap_true.
        matched = match( val = substring( val = input off = position ) regex = regex case = abap_false ).
      else.
        matched = match( val = substring( val = input off = position ) regex = regex case = abap_false ).
      endif.
    catch cx_root into data(err).
      data(text) = err->get_text( ).
    endtry.
    if matched is not initial.
      position = position + strlen( matched ).
      result = matched.
    endif.
  endmethod.
  method is_at_break.
    result = xsdbool( line_exists( breaks[ table_line = position ] ) ).
  endmethod.
  method skip_white_space.
    if skip_regex is not initial.
      match_text( skip_regex ).
    endif.
  endmethod.

  method apply_rule.
    data(start_position) = position.
    field-symbols <mmap> type parser_memo_entry_type_tab.
    if line_exists( memoization[ index = start_position ] ).
      assign memoization[ index = start_position ]-data to <mmap>.
    else.
      insert initial line into table memoization reference into data(ref_mem).
      ref_mem->index = start_position.
      assign ref_mem->data to <mmap>.
    endif.
    data(m) = recall( rule = rule pos = start_position ).
    if m is initial.
      data lr type ref to lr_type.
      create data lr.
      lr->rule = rule.
      lr->next = invocation_stack.
      invocation_stack = lr.
      append initial line to <mmap> assigning field-symbol(<mmap_line>).
      <mmap_line>-parser = rule.
      <mmap_line>-memo_entry = value memo_entry_type( lr = lr  position = start_position ).
      data(ans) = rule->match( me ).
      invocation_stack = cast lr_type( invocation_stack->next ).
      <mmap_line>-memo_entry-position = position.
      if lr->head is not initial.
          lr->seed = ans.
          result = lr_answer( exporting rule = rule pos = start_position changing m = <mmap_line>-memo_entry ).
      endif.
      clear <mmap_line>-memo_entry-lr.
      <mmap_line>-memo_entry-ans = ans.
      result = ans.
      return.
    endif.
    position = m-position.
    if m-lr is not initial.
        setup_lr( exporting rule = rule changing l = m-lr ).
        result = m-lr->seed.
    endif.
    result = m-ans.
  endmethod.
ENDCLASS.
