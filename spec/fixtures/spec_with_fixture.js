describe("Jasmine fixture example", function() {
  it("should work", function() {
    expect(document.getElementById('stuff')).toBeNull();
    JazzMoney.loadFixture('html_fixture')
    expect(document.getElementById('stuff').innerHTML).toEqual('Stuff')
  });
});