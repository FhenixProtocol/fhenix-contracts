const { expect } = require('chai');

/** Revert handler that supports custom errors. */
async function expectRevertCustomError(promise, expectedErrorName, args) {
  if (!Array.isArray(args)) {
    expect.fail('Expected 3rd array parameter for error arguments');
  }

  await promise.then(
    () => expect.fail("Expected promise to throw but it didn't"),
    ({ message }) => {
      // NOTE: When a tx revert in fhenix, the message is always the same, meaning we can't check the custom error name.
      // We could check the tx data, which is returned from the node on eth_calls, but it's stripped out of the error by
      // one of the web3 libraries.
      if (message !== "Returned error: execution reverted") {
        expect.fail(`Expected 'execution reverted' message`);
      }
    },
  );
}

module.exports = {
  expectRevertCustomError,
};
