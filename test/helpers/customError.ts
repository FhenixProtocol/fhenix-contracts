const { expect } = require('chai');

/** Revert handler that supports custom errors. */
async function expectRevertCustomError(promise, expectedErrorName, args) {
  if (!Array.isArray(args)) {
    expect.fail('Expected 3rd array parameter for error arguments');
  }

  await promise.then(
    () => expect.fail("Expected promise to throw but it didn't"),
    ({ message }) => {
      if (message !== "Returned error: execution reverted") {
        expect.fail(`Expected 'execution reverted' message`);
      }
    },
  );
}

module.exports = {
  expectRevertCustomError,
};
