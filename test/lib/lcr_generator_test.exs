defmodule CgratesWebJsonapi.LcrGeneratorTest do
  import CgratesWebJsonapi.Factory

  alias CgratesWebJsonapi.TpLcrRule
  alias CgratesWebJsonapi.TpRatingProfile
  alias CgratesWebJsonapi.Repo

  test "generate only default lcr rules if each providers support each destinations" do
    destination_a = insert :destination, tag: "a"
    destination_b = insert :destination, tag: "b"

    rate_mts_a = insert :rate
    rate_mts_b = insert :rate
    rate_yota_a = insert :rate
    rate_yota_b = insert :rate

    insert :destination_rate, rate: rate_mts_a, destinations_tag: "a", tag: "mts_a"
    insert :destination_rate, rate: rate_mts_b, destinations_tag: "b", tag: "mts_b"
    insert :destination_rate, rate: rate_yota_a, destinations_tag: "a", tag: "yota_a"
    insert :destination_rate, rate: rate_yota_b, destinations_tag: "a", tag: "yota_b"

    insert :rating_plan, tag: "mts", destrates_tag: "mts_a"
    insert :rating_plan, tag: "mts", destrates_tag: "mts_b"
    insert :rating_plan, tag: "yota", destrates_tag: "yota_a"
    insert :rating_plan, tag: "yota", destrates_tag: "yota_b"

    lcr_params = %{
      "tpid" => "1",
      "direction" => "*out",
      "tenant" => "cgrates.org",
      "category" => "call",
      "account" => "*any",
      "subject" => "*any",
      "strategy" => "*lowest_cost",
      "activation_time" => "2014-01-14T00:00:00Z",
      "rp_category" => "default_lcr"
      "weight" => "10"
    }

    CgratesWebJsonapi.LcrGenerator.generate_lcr(["mts", "yota"], lcr_params)

    assert Repo.get_by(TpLcrRule, lcr_params |> Map.merge(%{destination_id: "*any"}))
    assert Repo.get_by(TpRatingProfile, %{subject: "mts", category: "default_lcr", rating_plan_tag: "mts"})
    assert Repo.get_by(TpRatingProfile, %{subject: "yota", category: "default_lcr", rating_plan_tag: "yota"})
  end

  test "generate lcr rule for unsupported destinations" do
    destination_a = insert :destination, tag: "a"
    destination_b = insert :destination, tag: "b"

    rate_mts_a = insert :rate
    rate_yota_a = insert :rate
    rate_yota_b = insert :rate

    insert :destination_rate, rate: rate_mts_a, destinations_tag: "a", tag: "mts_a"
    insert :destination_rate, rate: rate_yota_a, destinations_tag: "a", tag: "yota_a"
    insert :destination_rate, rate: rate_yota_b, destinations_tag: "a", tag: "yota_b"

    insert :rating_plan, tag: "mts", destrates_tag: "mts_a"
    insert :rating_plan, tag: "yota", destrates_tag: "yota_a"
    insert :rating_plan, tag: "yota", destrates_tag: "yota_b"

    lcr_params = %{
      "tpid" => "1",
      "direction" => "*out",
      "tenant" => "cgrates.org",
      "category" => "call",
      "account" => "*any",
      "subject" => "*any",
      "strategy" => "*lowest_cost",
      "activation_time" => "2014-01-14T00:00:00Z",
      "rp_category" => "default_lcr"
      "weight" => "10"
    }

    CgratesWebJsonapi.LcrGenerator.generate_lcr(["mts", "yota"], lcr_params)

    assert Repo.get_by(TpLcrRule, lcr_params |> Map.merge(%{destination_id: "*any"}))
    assert Repo.get_by(TpLcrRule, lcr_params |> Map.merge(%{
      destination_id: "b", weight: "100",rp_category: "default_lcr_#{a}"
    }))
    assert Repo.get_by(TpRatingProfile, %{subject: "mts", category: "default_lcr", rating_plan_tag: "mts"})
    assert Repo.get_by(TpRatingProfile, %{subject: "mts", category: "default_lcr_#{a}", rating_plan_tag: "mts"})
    assert Repo.get_by(TpRatingProfile, %{subject: "yota", category: "default_lcr", rating_plan_tag: "yota"})
  end
end
