require 'spec_helper'
require 'eatl/dot_generator'

describe Eatl::DotGenerator do
  let(:schema) { './spec/fixtures/schema/book.yaml' }
  subject { described_class.new(schema) }

  it "generates a valid DOT file of the table schema" do
    expect(subject.to_dot).to eq(<<-DOT)
digraph g {
  ranksep="1.6"
  graph [
  rankdir = "LR"
  ];
  node [
  fontsize = "16"
  ];
  edge [
  arrowhead = "none"
  ];
"books" [shape=none, margin=0, label=<
  <table border="0" cellborder="1" cellspacing="0" cellpadding="4">
    <tr><td bgcolor="lightblue">books</td></tr>
    <tr><td port="id" align="left">id</td></tr>
    <tr><td port="author" align="left">author</td></tr>
    <tr><td port="pages" align="left">pages</td></tr>
    <tr><td port="for_sale" align="left">for_sale</td></tr>
    <tr><td port="published_at" align="left">published_at</td></tr>
    <tr><td port="rating" align="left">rating</td></tr>
    <tr><td port="icbn" align="left">icbn</td></tr>
    <tr><td port="summary" align="left">summary</td></tr>
    <tr><td port="age" align="left">age</td></tr>
  </table>>];
}
    DOT
  end

  context 'with multiple related tables' do
    let(:schema) { ['./spec/fixtures/schema/book.yaml', './spec/fixtures/schema/chapters.yaml']  }

    it "generates a valid DOT file of the table schema" do
      expect(subject.to_dot).to eq(<<-DOT)
digraph g {
  ranksep="1.6"
  graph [
  rankdir = "LR"
  ];
  node [
  fontsize = "16"
  ];
  edge [
  arrowhead = "none"
  ];
"books" [shape=none, margin=0, label=<
  <table border="0" cellborder="1" cellspacing="0" cellpadding="4">
    <tr><td bgcolor="lightblue">books</td></tr>
    <tr><td port="id" align="left">id</td></tr>
    <tr><td port="author" align="left">author</td></tr>
    <tr><td port="pages" align="left">pages</td></tr>
    <tr><td port="for_sale" align="left">for_sale</td></tr>
    <tr><td port="published_at" align="left">published_at</td></tr>
    <tr><td port="rating" align="left">rating</td></tr>
    <tr><td port="icbn" align="left">icbn</td></tr>
    <tr><td port="summary" align="left">summary</td></tr>
    <tr><td port="age" align="left">age</td></tr>
  </table>>];
"chapters" [shape=none, margin=0, label=<
  <table border="0" cellborder="1" cellspacing="0" cellpadding="4">
    <tr><td bgcolor="lightblue">chapters</td></tr>
    <tr><td port="book_id" align="left">book_id</td></tr>
    <tr><td port="title" align="left">title</td></tr>
  </table>>];
"chapters":"book_id" -> "books":"id" [style="dashed" dir="back" arrowtail="veevee"];
}
      DOT
    end
  end
end
