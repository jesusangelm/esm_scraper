defmodule EsmScraper do
  @moduledoc """
  Documentation for EsmScraper.
  """

  def parser(dom) do
    classifieds_dom = Floki.find(dom, ".classified")
    Enum.map classifieds_dom, &(&1 |> Floki.DeepText.get |> String.replace("\n", ""))
  end

  def get_classifieds(type) do
    dom = html_requester(type)
    dom.body |> parser()
  end

  def html_requester(:apartment_rent), do: "http://www.elsoldemargarita.com.ve/clasificados/index/fsection:1" |> HTTPoison.get!
  def html_requester(:house_rent), do: "http://www.elsoldemargarita.com.ve/clasificados/index/fsection:4" |> HTTPoison.get!
end
