require "spec_helper"

RSpec.describe SuperDiff::ObjectInspection do
  describe ".inspect" do
    context "given nil" do
      context "given single_line: true" do
        it "returns nil, inspected" do
          inspection = described_class.inspect(nil, single_line: true)
          expect(inspection).to eq("nil")
        end
      end

      context "given single_line: false" do
        it "returns nil, inspected" do
          inspection = described_class.inspect(nil, single_line: false)
          expect(inspection).to eq("nil")
        end
      end
    end

    context "given true" do
      context "given single_line: true" do
        it "returns nil, inspected" do
          inspection = described_class.inspect(nil, single_line: true)
          expect(inspection).to eq("nil")
        end
      end

      context "given single_line: false" do
        it "returns nil, inspected" do
          inspection = described_class.inspect(nil, single_line: false)
          expect(inspection).to eq("nil")
        end
      end
    end

    context "given false" do
      context "given single_line: false" do
        it "returns false, inspected" do
          inspection = described_class.inspect(false, single_line: false)
          expect(inspection).to eq("false")
        end
      end

      context "given single_line: false" do
        it "returns false, inspected" do
          inspection = described_class.inspect(false, single_line: false)
          expect(inspection).to eq("false")
        end
      end
    end

    context "given a number" do
      context "given single_line: true" do
        it "returns the number as a string" do
          inspection = described_class.inspect(3, single_line: true)
          expect(inspection).to eq("3")
        end
      end

      context "given single_line: false" do
        it "returns the number as a string" do
          inspection = described_class.inspect(3, single_line: false)
          expect(inspection).to eq("3")
        end
      end
    end

    context "given a symbol" do
      context "given single_line: true" do
        it "returns the symbol, inspected" do
          inspection = described_class.inspect(:foo, single_line: true)
          expect(inspection).to eq(":foo")
        end
      end

      context "given single_line: false" do
        it "returns the symbol, inspected" do
          inspection = described_class.inspect(:foo, single_line: false)
          expect(inspection).to eq(":foo")
        end
      end
    end

    context "given a single-line string" do
      it "returns the string surrounded by quotes" do
        inspection = described_class.inspect("Marty", single_line: true)
        expect(inspection).to eq('"Marty"')
      end
    end

    context "given a multi-line string" do
      it "returns the string surrounded by quotes, with newline characters replaced for display purposes" do
        inspection = described_class.inspect(
          "This is a line\nAnd that's a line\nAnd there's a line too",
          single_line: true,
        )
        expect(inspection).to eq(
          %("This is a line⏎And that's a line⏎And there's a line too"),
        )
      end
    end

    context "given an array" do
      context "containing only primitive values" do
        context "given single_line: true" do
          it "returns a representation of the array on a single line" do
            inspection = described_class.inspect(
              ["foo", 2, :baz],
              single_line: true,
            )
            expect(inspection).to eq(%(["foo", 2, :baz]))
          end
        end

        context "given single_line: false" do
          it "returns a representation of the array across multiple lines" do
            inspection = described_class.inspect(
              ["foo", 2, :baz],
              single_line: false,
            )
            expect(inspection).to eq(<<~INSPECTION.rstrip)
              [
                "foo",
                2,
                :baz
              ]
            INSPECTION
          end
        end
      end

      context "containing other arrays" do
        context "given single_line: true" do
          it "returns a representation of the array on a single line" do
            inspection = described_class.inspect(
              [
                "foo",
                ["bar", "baz"],
                "qux",
              ],
              single_line: true,
            )
            expect(inspection).to eq(%(["foo", ["bar", "baz"], "qux"]))
          end
        end

        context "given single_line: false" do
          it "returns a representation of the array across multiple lines" do
            inspection = described_class.inspect(
              [
                "foo",
                ["bar", "baz"],
                "qux",
              ],
              single_line: false,
            )
            expect(inspection).to eq(<<~INSPECTION.rstrip)
              [
                "foo",
                [
                  "bar",
                  "baz"
                ],
                "qux"
              ]
            INSPECTION
          end
        end
      end
    end

    context "given a hash" do
      context "containing only primitive values" do
        context "where all of the keys are symbols" do
          context "given single_line: true" do
            it "returns a representation of the hash on a single line" do
              inspection = described_class.inspect(
                # rubocop:disable Style/HashSyntax
                { :foo => "bar", :baz => "qux" },
                # rubocop:enable Style/HashSyntax
                single_line: true,
              )
              expect(inspection).to eq(%({ foo: "bar", baz: "qux" }))
            end
          end

          context "given single_line: false" do
            it "returns a representation of the hash across multiple lines" do
              inspection = described_class.inspect(
                # rubocop:disable Style/HashSyntax
                { :foo => "bar", :baz => "qux" },
                # rubocop:enable Style/HashSyntax
                single_line: false,
              )
              expect(inspection).to eq(<<~INSPECTION.rstrip)
                {
                  foo: "bar",
                  baz: "qux"
                }
              INSPECTION
            end
          end
        end

        context "where only some of the keys are symbols" do
          context "given single_line: true" do
            it "returns a representation of the hash on a single line" do
              inspection = described_class.inspect(
                { :foo => "bar", 2 => "baz" },
                single_line: true,
              )
              expect(inspection).to eq(%({ :foo => "bar", 2 => "baz" }))
            end
          end

          context "given single_line: false" do
            it "returns a representation of the hash across multiple lines" do
              inspection = described_class.inspect(
                { :foo => "bar", 2 => "baz" },
                single_line: false,
              )
              expect(inspection).to eq(<<~INSPECTION.rstrip)
                {
                  :foo => "bar",
                  2 => "baz"
                }
              INSPECTION
            end
          end
        end
      end

      context "containing other hashes" do
        context "given single_line: true" do
          it "returns a representation of the hash on a single line" do
            # TODO: Update this with a key/value pair before AND after
            value_to_inspect = {
              # rubocop:disable Style/HashSyntax
              :category_name => "Appliances",
              :products_by_sku => {
                "EMDL-2934" => { :id => 4, :name => "Jordan Air" },
                "KDS-3912" => { :id => 8, :name => "Chevy Impala" },
              },
              :number_of_products => 2,
              # rubocop:enable Style/HashSyntax
            }
            inspection = described_class.inspect(
              value_to_inspect,
              single_line: true,
            )
            # rubocop:disable Metrics/LineLength
            expect(inspection).to eq(
              %({ category_name: "Appliances", products_by_sku: { "EMDL-2934" => { id: 4, name: "Jordan Air" }, "KDS-3912" => { id: 8, name: "Chevy Impala" } }, number_of_products: 2 }),
            )
            # rubocop:enable Metrics/LineLength
          end
        end

        context "given single_line: false" do
          it "returns a representation of the array across multiple lines" do
            value_to_inspect = {
              # rubocop:disable Style/HashSyntax
              :category_name => "Appliances",
              :products_by_sku => {
                "EMDL-2934" => { :id => 4, :name => "George Foreman Grill" },
                "KDS-3912" => { :id => 8, :name => "Magic Bullet" },
              },
              :number_of_products => 2,
              # rubocop:enable Style/HashSyntax
            }
            inspection = described_class.inspect(
              value_to_inspect,
              single_line: false,
            )
            expect(inspection).to eq(<<~INSPECTION.rstrip)
              {
                category_name: "Appliances",
                products_by_sku: {
                  "EMDL-2934" => {
                    id: 4,
                    name: "George Foreman Grill"
                  },
                  "KDS-3912" => {
                    id: 8,
                    name: "Magic Bullet"
                  }
                },
                number_of_products: 2
              }
            INSPECTION
          end
        end
      end
    end

    context "given a custom object" do
      context "containing only primitive values" do
        context "given single_line: true" do
          it "returns a representation of the object on a single line" do
            inspection = described_class.inspect(
              SuperDiff::Test::Person.new(name: "Doc", age: 58),
              single_line: true,
            )
            expect(inspection).to eq(
              %(#<SuperDiff::Test::Person name: "Doc", age: 58>),
            )
          end
        end

        context "given single_line: false" do
          it "returns a representation of the object across multiple lines" do
            inspection = described_class.inspect(
              SuperDiff::Test::Person.new(name: "Doc", age: 58),
              single_line: false,
            )
            expect(inspection).to eq(<<~INSPECTION.rstrip)
              #<SuperDiff::Test::Person {
                name: "Doc",
                age: 58
              }>
            INSPECTION
          end
        end
      end

      context "containing other custom objects" do
        context "given single_line: true" do
          it "returns a representation of the object on a single line" do
            inspection = described_class.inspect(
              SuperDiff::Test::Customer.new(
                name: "Marty McFly",
                shipping_address: SuperDiff::Test::ShippingAddress.new(
                  line_1: "123 Main St.",
                  line_2: "",
                  city: "Hill Valley",
                  state: "CA",
                  zip: "90382",
                ),
                phone: "111-222-3333",
              ),
              single_line: true,
            )
            expect(inspection).to eq(
              # rubocop:disable Metrics/LineLength
              %(#<SuperDiff::Test::Customer name: "Marty McFly", shipping_address: #<SuperDiff::Test::ShippingAddress line_1: "123 Main St.", line_2: "", city: "Hill Valley", state: "CA", zip: "90382">, phone: "111-222-3333">),
              # rubocop:enable Metrics/LineLength
            )
          end
        end

        context "given single_line: false" do
          it "returns a representation of the object across multiple lines" do
            inspection = described_class.inspect(
              SuperDiff::Test::Customer.new(
                name: "Marty McFly",
                shipping_address: SuperDiff::Test::ShippingAddress.new(
                  line_1: "123 Main St.",
                  line_2: "",
                  city: "Hill Valley",
                  state: "CA",
                  zip: "90382",
                ),
                phone: "111-222-3333",
              ),
              single_line: false,
            )
            expect(inspection).to eq(<<~INSPECTION.rstrip)
              #<SuperDiff::Test::Customer {
                name: "Marty McFly",
                shipping_address: #<SuperDiff::Test::ShippingAddress {
                  line_1: "123 Main St.",
                  line_2: "",
                  city: "Hill Valley",
                  state: "CA",
                  zip: "90382"
                }>,
                phone: "111-222-3333"
              }>
            INSPECTION
          end
        end
      end
    end

    context "given a non-custom object" do
      context "containing only primitive values" do
        context "given single_line: true" do
          it "returns a representation of the object on a single line" do
            inspection = described_class.inspect(
              SuperDiff::Test::Item.new(
                name: "mac and cheese",
                quantity: 2,
              ),
              single_line: true,
            )
            expect(inspection).to match(
              # rubocop:disable Metrics/LineLength
              /\A#<SuperDiff::Test::Item:0x[a-z0-9]+ @name="mac and cheese" @quantity=2>\Z/,
              # rubocop:enable Metrics/LineLength
            )
          end
        end

        context "given single_line: false" do
          it "returns a representation of the object across multiple lines" do
            inspection = described_class.inspect(
              SuperDiff::Test::Item.new(
                name: "mac and cheese",
                quantity: 2,
              ),
              single_line: false,
            )
            regexp = <<~INSPECTION.rstrip
              #<SuperDiff::Test::Item:0x[a-z0-9]+ \\{
                @name="mac and cheese",
                @quantity=2
              \\}>
            INSPECTION
            expect(inspection).to match(/\A#{regexp}\Z/)
          end
        end
      end

      context "containing other custom objects" do
        context "given single_line: true" do
          it "returns a representation of the object on a single line" do
            inspection = described_class.inspect(
              SuperDiff::Test::Order.new([
                SuperDiff::Test::Item.new(name: "ham", quantity: 1),
                SuperDiff::Test::Item.new(name: "eggs", quantity: 2),
                SuperDiff::Test::Item.new(name: "cheese", quantity: 1),
              ]),
              single_line: true,
            )
            expect(inspection).to match(
              # rubocop:disable Metrics/LineLength
              /\A#<SuperDiff::Test::Order:0x[a-z0-9]+ @items=\[#<SuperDiff::Test::Item:0x[a-z0-9]+ @name="ham" @quantity=1>, #<SuperDiff::Test::Item:0x[a-z0-9]+ @name="eggs" @quantity=2>, #<SuperDiff::Test::Item:0x[a-z0-9]+ @name="cheese" @quantity=1>\]>\Z/,
              # rubocop:enable Metrics/LineLength
            )
          end
        end

        context "given single_line: false" do
          it "returns a representation of the object across multiple lines" do
            inspection = described_class.inspect(
              SuperDiff::Test::Order.new([
                SuperDiff::Test::Item.new(name: "ham", quantity: 1),
                SuperDiff::Test::Item.new(name: "eggs", quantity: 2),
                SuperDiff::Test::Item.new(name: "cheese", quantity: 1),
              ]),
              single_line: false,
            )
            regexp = <<~INSPECTION.rstrip
              #<SuperDiff::Test::Order:0x[a-z0-9]+ \\{
                @items=\\[
                  #<SuperDiff::Test::Item:0x[a-z0-9]+ \\{
                    @name="ham",
                    @quantity=1
                  \\}>,
                  #<SuperDiff::Test::Item:0x[a-z0-9]+ \\{
                    @name="eggs",
                    @quantity=2
                  \\}>,
                  #<SuperDiff::Test::Item:0x[a-z0-9]+ \\{
                    @name="cheese",
                    @quantity=1
                  \\}>
                \\]
              }>
            INSPECTION
            expect(inspection).to match(/\A#{regexp}\Z/)
          end
        end
      end
    end

    context "given a combination of all kinds of values" do
      context "given single_line: true" do
        it "returns a representation of the object on a single line" do
          inspection = described_class.inspect(
            {
              state: :down,
              errors: [
                "Container A-234 is partially damaged",
                "Vessel B042 was attacked by raccoons",
                "Product FDK-3429 is out of stock",
              ],
              mission_critical: true,
              serviceable: false,
              outstanding_orders: [
                SuperDiff::Test::Order.new([
                  SuperDiff::Test::Item.new(name: "ham", quantity: 1),
                  SuperDiff::Test::Item.new(name: "eggs", quantity: 2),
                  SuperDiff::Test::Item.new(name: "cheese", quantity: 1),
                ]),
              ],
              customers: [
                SuperDiff::Test::Customer.new(
                  name: "Marty McFly",
                  shipping_address: SuperDiff::Test::ShippingAddress.new(
                    line_1: "123 Baltic Ave.",
                    line_2: "",
                    city: "Hill Valley",
                    state: "CA",
                    zip: "90382",
                  ),
                  phone: "111-111-1111",
                ),
                SuperDiff::Test::Customer.new(
                  name: "Doc Brown",
                  shipping_address: SuperDiff::Test::ShippingAddress.new(
                    line_1: "456 Park Place",
                    line_2: "",
                    city: "Beverly Hills",
                    state: "CA",
                    zip: "90210",
                  ),
                  phone: "222-222-2222",
                ),
              ],
            },
            single_line: true,
          )
          expect(inspection).to match(
            # rubocop:disable Metrics/LineLength
            /\A{ state: :down, errors: \["Container A-234 is partially damaged", "Vessel B042 was attacked by raccoons", "Product FDK-3429 is out of stock"\], mission_critical: true, serviceable: false, outstanding_orders: \[#<SuperDiff::Test::Order:0x[a-z0-9]+ @items=\[#<SuperDiff::Test::Item:0x[a-z0-9]+ @name="ham" @quantity=1>, #<SuperDiff::Test::Item:0x[a-z0-9]+ @name="eggs" @quantity=2>, #<SuperDiff::Test::Item:0x[a-z0-9]+ @name="cheese" @quantity=1>\]>\], customers: \[#<SuperDiff::Test::Customer name: "Marty McFly", shipping_address: #<SuperDiff::Test::ShippingAddress line_1: "123 Baltic Ave.", line_2: "", city: "Hill Valley", state: "CA", zip: "90382">, phone: "111-111-1111">, #<SuperDiff::Test::Customer name: "Doc Brown", shipping_address: #<SuperDiff::Test::ShippingAddress line_1: "456 Park Place", line_2: "", city: "Beverly Hills", state: "CA", zip: "90210">, phone: "222-222-2222">\] }\Z/,
            # rubocop:enable Metrics/LineLength
          )
        end
      end

      context "given single_line: false" do
        it "returns a representation of the object across multiple lines" do
          inspection = described_class.inspect(
            {
              state: :down,
              errors: [
                "Container A-234 is partially damaged",
                "Vessel B042 was attacked by raccoons",
                "Product FDK-3429 is out of stock",
              ],
              mission_critical: true,
              serviceable: false,
              outstanding_orders: [
                SuperDiff::Test::Order.new([
                  SuperDiff::Test::Item.new(name: "ham", quantity: 1),
                  SuperDiff::Test::Item.new(name: "eggs", quantity: 2),
                  SuperDiff::Test::Item.new(name: "cheese", quantity: 1),
                ]),
              ],
              customers: [
                SuperDiff::Test::Customer.new(
                  name: "Marty McFly",
                  shipping_address: SuperDiff::Test::ShippingAddress.new(
                    line_1: "123 Baltic Ave.",
                    line_2: "",
                    city: "Hill Valley",
                    state: "CA",
                    zip: "90382",
                  ),
                  phone: "111-111-1111",
                ),
                SuperDiff::Test::Customer.new(
                  name: "Doc Brown",
                  shipping_address: SuperDiff::Test::ShippingAddress.new(
                    line_1: "456 Park Place",
                    line_2: "",
                    city: "Beverly Hills",
                    state: "CA",
                    zip: "90210",
                  ),
                  phone: "222-222-2222",
                ),
              ],
            },
            single_line: false,
          )
          regexp = <<~INSPECTION.rstrip
            \\{
              state: :down,
              errors: \\[
                "Container A-234 is partially damaged",
                "Vessel B042 was attacked by raccoons",
                "Product FDK-3429 is out of stock"
              \\],
              mission_critical: true,
              serviceable: false,
              outstanding_orders: \\[
                #<SuperDiff::Test::Order:0x[a-z0-9]+ \\{
                  @items=\\[
                    #<SuperDiff::Test::Item:0x[a-z0-9]+ \\{
                      @name="ham",
                      @quantity=1
                    \\}>,
                    #<SuperDiff::Test::Item:0x[a-z0-9]+ \\{
                      @name="eggs",
                      @quantity=2
                    \\}>,
                    #<SuperDiff::Test::Item:0x[a-z0-9]+ \\{
                      @name="cheese",
                      @quantity=1
                    \\}>
                  \\]
                \\}>
              \\],
              customers: \\[
                #<SuperDiff::Test::Customer \\{
                  name: "Marty McFly",
                  shipping_address: #<SuperDiff::Test::ShippingAddress \\{
                    line_1: "123 Baltic Ave.",
                    line_2: "",
                    city: "Hill Valley",
                    state: "CA",
                    zip: "90382"
                  \\}>,
                  phone: "111-111-1111"
                \\}>,
                #<SuperDiff::Test::Customer \\{
                  name: "Doc Brown",
                  shipping_address: #<SuperDiff::Test::ShippingAddress \\{
                    line_1: "456 Park Place",
                    line_2: "",
                    city: "Beverly Hills",
                    state: "CA",
                    zip: "90210"
                  \\}>,
                  phone: "222-222-2222"
                \\}>
              \\]
            \\}
          INSPECTION
          expect(inspection).to match(/\A#{regexp}\Z/)
        end
      end
    end
  end
end