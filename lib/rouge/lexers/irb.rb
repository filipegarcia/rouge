# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    require_relative 'console.rb'

    class IRBLexer < ConsoleLexer
      tag 'irb'
      aliases 'pry'

      desc 'Shell sessions in IRB or Pry'

      # unlike the superclass, we do not accept any options
      @option_docs = {}

      def output_lexer
        @output_lexer ||= IRBOutputLexer.new(@options)
      end

      def lang_lexer
        @lang_lexer ||= Ruby.new(@options)
      end

      def prompt_regex
        /^.*?(irb|pry).*?[>"*]/
      end

      def allow_comments?
        true
      end
    end

    require_relative 'ruby.rb'
    class IRBOutputLexer < Ruby
      tag 'irb_output'

      start do
        push :stdout
      end

      state :has_irb_output do
        rule %r(=>), Punctuation, :pop!
        rule /.+?(\n|$)/, Generic::Output
      end

      state :irb_error do
        rule /.+?(\n|$)/, Generic::Error
        mixin :has_irb_output
      end

      state :stdout do
        rule /\w+?(Error|Exception):.+?(\n|$)/, Generic::Error, :irb_error
        mixin :has_irb_output
      end

      prepend :root do
        rule /#</, Keyword::Type, :irb_object
      end

      state :irb_object do
        rule />/, Keyword::Type, :pop!
        mixin :root
      end
    end
  end
end
