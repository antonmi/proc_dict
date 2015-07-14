defmodule CellSpec do
  use ESpec

  let :cell do
    Cell.new(20)
  end

  describe "get" do
    it do: expect(Cell.get(cell)).to eq(20)
  end

  describe "set" do
    before do: {:ok, result: Cell.set(cell, 30)}

    it do: expect(__.result).to eq(:ok)
    it do: expect(Cell.get(cell)).to eq(30)
  end

end