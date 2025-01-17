#
#  Test name
#
TEST := test.dict

#
#  Input files.
#
FILES := $(wildcard $(DIR)/*.dict)

$(eval $(call TEST_BOOTSTRAP))

#  And the actual script to run each test.
#
#  The parser expects to read "foo/dictionary", so we make a
#  "foo_dir" directory, and copy "foo" into "foo_dir/dictionary"
#
$(OUTPUT)/%: $(DIR)/% $(TESTBINDIR)/unit_test_attribute
	${Q}echo DICT-TEST $(notdir $@)
	${Q}mkdir -p $@_dir
	${Q}cp $< $@_dir/dictionary
	${Q}if ! $(TESTBIN)/unit_test_attribute -D $(top_srcdir)/share/dictionary -d "$@_dir" -r "$@" -xxx "$(dir $<)/empty.txt" > "$@.log" 2>&1 || ! test -f "$@"; then \
		echo "$(TESTBIN)/unit_test_attribute -D $(top_srcdir)/share/dictionary -d \"$@_dir\" -r \"$@\" \"$(dir $<)/empty.txt\""; \
		cat "$@.log"; \
		rm -f $(BUILD_DIR)/tests/test.dict; \
		exit 1; \
	fi
