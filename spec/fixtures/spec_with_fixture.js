describe("Jasmine fixture example", function() {
  it("should work", function() {
    alert(JSON.stringify(JazzMoney.allFixtures))
    expect(JazzMoney.allFixtures['html_fixture']).toEqual('<div id="stuff">Stuff</div>');
  });
});