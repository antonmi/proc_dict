defmodule ProcDictSpec do
  use ESpec

  let :dict, do: ProcDict.new

  before do
    dict 
    |> ProcDict.put(:a, 1)
    |> ProcDict.put(:b, 2)
  end

  it do: ProcDict.size(dict) |> should eq(2)

  describe "fetch" do
    it do: expect(ProcDict.fetch(dict, :a)).to eq({:ok, 1})
    it do: expect(ProcDict.fetch(dict, :b)).to eq({:ok, 2})
    it do: expect(ProcDict.fetch(dict, :c)).to eq(:error)
  end

  describe "delete" do
    before do
      ProcDict.delete(dict, :a)
      ProcDict.delete(dict, :c)
    end

    it do: expect(ProcDict.fetch(dict, :a)).to eq(:error)
    it do: expect(ProcDict.fetch(dict, :b)).to eq({:ok, 2})

    it do: ProcDict.size(dict) |> should eq(1)
  end

  describe "reduce" do
    let :fun do
      fn({k, v}, acc) ->
        [{k, v} | acc]
      end
    end

    it do: expect(ProcDict.reduce(dict, [], fun)).to eq([a: 1, b: 2])
  end

  context "use Dict functions" do
    describe "get" do
      it do: expect(ProcDict.get(dict, :a)).to eq(1)
      it do: expect(ProcDict.get(dict, :b)).to eq(2)
      it do: expect(ProcDict.get(dict, :c)).to eq(nil)
      it do: expect(ProcDict.get(dict, :c, 100)).to eq(100)
    end

    describe "keys" do
      it do:  expect(ProcDict.values(dict)).to eq([:a, :b])
    end
  end


end