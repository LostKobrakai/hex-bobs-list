defmodule BobVersionsTest do
  use ExUnit.Case, async: true

  describe "text_to_data/1" do
    test "success V1" do
      string = """
      v0.12.4 543dfdeac80cfaf3483927c189cf9974f1e361eb 2016-06-02T12:43:53Z
      v0.12.5 b07fbcf8b73e9353cc336107050a8aac5fdabd11 2016-06-02T12:42:56Z
      v0.13.0 ada53524caa6ea27ffaa1a373f5c86bd6cadb0d5 2016-06-02T12:42:00Z
      """

      assert %{
               "v0.12" => [
                 %{
                   git: %{
                     sha: "543dfdeac80cfaf3483927c189cf9974f1e361eb",
                     url:
                       "https://github.com/elixir-lang/elixir/commit/543dfdeac80cfaf3483927c189cf9974f1e361eb"
                   },
                   minor_version: "v0.12",
                   version: "v0.12.4",
                   versions: [
                     %{
                       availability: :undetermined,
                       checksum: "",
                       download: "https://repo.hex.pm/builds/elixir/v0.12.4.zip",
                       git: %{
                         sha: "543dfdeac80cfaf3483927c189cf9974f1e361eb",
                         url:
                           "https://github.com/elixir-lang/elixir/commit/543dfdeac80cfaf3483927c189cf9974f1e361eb"
                       },
                       timestamp: ~U[2016-06-02 12:43:53Z],
                       version: %{elixir: "v0.12.4", otp: "Default"}
                     }
                   ]
                 },
                 %{
                   git: %{
                     sha: "b07fbcf8b73e9353cc336107050a8aac5fdabd11",
                     url:
                       "https://github.com/elixir-lang/elixir/commit/b07fbcf8b73e9353cc336107050a8aac5fdabd11"
                   },
                   minor_version: "v0.12",
                   version: "v0.12.5",
                   versions: [
                     %{
                       availability: :undetermined,
                       checksum: "",
                       download: "https://repo.hex.pm/builds/elixir/v0.12.5.zip",
                       git: %{
                         sha: "b07fbcf8b73e9353cc336107050a8aac5fdabd11",
                         url:
                           "https://github.com/elixir-lang/elixir/commit/b07fbcf8b73e9353cc336107050a8aac5fdabd11"
                       },
                       timestamp: ~U[2016-06-02 12:42:56Z],
                       version: %{elixir: "v0.12.5", otp: "Default"}
                     }
                   ]
                 }
               ],
               "v0.13" => [
                 %{
                   git: %{
                     sha: "ada53524caa6ea27ffaa1a373f5c86bd6cadb0d5",
                     url:
                       "https://github.com/elixir-lang/elixir/commit/ada53524caa6ea27ffaa1a373f5c86bd6cadb0d5"
                   },
                   minor_version: "v0.13",
                   version: "v0.13.0",
                   versions: [
                     %{
                       availability: :undetermined,
                       checksum: "",
                       download: "https://repo.hex.pm/builds/elixir/v0.13.0.zip",
                       git: %{
                         sha: "ada53524caa6ea27ffaa1a373f5c86bd6cadb0d5",
                         url:
                           "https://github.com/elixir-lang/elixir/commit/ada53524caa6ea27ffaa1a373f5c86bd6cadb0d5"
                       },
                       timestamp: ~U[2016-06-02 12:42:00Z],
                       version: %{elixir: "v0.13.0", otp: "Default"}
                     }
                   ]
                 }
               ]
             } = BobVersions.text_to_data(string, availability: &undetermined_availability/1)
    end

    test "success V2" do
      string = """
      v0.12.4 543dfdeac80cfaf3483927c189cf9974f1e361eb 2016-06-02T12:43:53Z 950f5a6784cb556199797c6f7f0205db5c17dbbf1a7ce0aabdf575429c16c89c
      v0.12.5 b07fbcf8b73e9353cc336107050a8aac5fdabd11 2016-06-02T12:42:56Z d11c2d82a603a1362797a181dd8c8a2a5d6d9c6e5e54cfb03e8cb96443b91828
      """

      assert %{
               "v0.12" => [
                 %{
                   git: %{
                     sha: "543dfdeac80cfaf3483927c189cf9974f1e361eb",
                     url:
                       "https://github.com/elixir-lang/elixir/commit/543dfdeac80cfaf3483927c189cf9974f1e361eb"
                   },
                   minor_version: "v0.12",
                   version: "v0.12.4",
                   versions: [
                     %{
                       availability: :undetermined,
                       checksum:
                         "950f5a6784cb556199797c6f7f0205db5c17dbbf1a7ce0aabdf575429c16c89c",
                       download: "https://repo.hex.pm/builds/elixir/v0.12.4.zip",
                       git: %{
                         sha: "543dfdeac80cfaf3483927c189cf9974f1e361eb",
                         url:
                           "https://github.com/elixir-lang/elixir/commit/543dfdeac80cfaf3483927c189cf9974f1e361eb"
                       },
                       timestamp: ~U[2016-06-02 12:43:53Z],
                       version: %{elixir: "v0.12.4", otp: "Default"}
                     }
                   ]
                 },
                 %{
                   git: %{
                     sha: "b07fbcf8b73e9353cc336107050a8aac5fdabd11",
                     url:
                       "https://github.com/elixir-lang/elixir/commit/b07fbcf8b73e9353cc336107050a8aac5fdabd11"
                   },
                   minor_version: "v0.12",
                   version: "v0.12.5",
                   versions: [
                     %{
                       availability: :undetermined,
                       checksum:
                         "d11c2d82a603a1362797a181dd8c8a2a5d6d9c6e5e54cfb03e8cb96443b91828",
                       download: "https://repo.hex.pm/builds/elixir/v0.12.5.zip",
                       git: %{
                         sha: "b07fbcf8b73e9353cc336107050a8aac5fdabd11",
                         url:
                           "https://github.com/elixir-lang/elixir/commit/b07fbcf8b73e9353cc336107050a8aac5fdabd11"
                       },
                       timestamp: ~U[2016-06-02 12:42:56Z],
                       version: %{elixir: "v0.12.5", otp: "Default"}
                     }
                   ]
                 }
               ]
             } = BobVersions.text_to_data(string, availability: &undetermined_availability/1)
    end

    test "does ignore additional data" do
      string = """
      v0.12.4 543dfdeac80cfaf3483927c189cf9974f1e361eb 2016-06-02T12:43:53Z 950f5a6784cb556199797c6f7f0205db5c17dbbf1a7ce0aabdf575429c16c89c 123
      v0.12.5 b07fbcf8b73e9353cc336107050a8aac5fdabd11 2016-06-02T12:42:56Z d11c2d82a603a1362797a181dd8c8a2a5d6d9c6e5e54cfb03e8cb96443b91828 123 456
      """

      assert %{"v0.12" => [_, _]} =
               BobVersions.text_to_data(string, availability: &undetermined_availability/1)
    end
  end

  defp undetermined_availability(list) do
    Enum.map(list, fn item -> Map.put(item, :availability, :undetermined) end)
  end
end
