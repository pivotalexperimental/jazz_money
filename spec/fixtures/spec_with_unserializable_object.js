describe("Jasmine unserializable object example", function() {
  it("should work", function() {
    JazzMoney.loadFixture('html_fixture');
    expect(document.getElementById('stuff')).toEqual(document.getElementById('more-stuff'));
  });
});