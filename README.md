Port of open-location-code-swift towards Objective C.

See https://github.com/google/open-location-code-swift for their details.

main.c runs some tests, obtained from the open-location-code repository.
- encodingTests.csv	- Convert code to area, lat/lon to code.
- shortCodeTests.csv	- Test shortening and extending codes.
- validityTests.csv	- Test isValid,isShort,isFull

If the output returns '_', then the test was not run on purpose.
If the output returns '.', then the test was successful.
If the output returns '<', then the test was successful but the
    returned string was more precise than the expected.
If the output returns '(...)', then the test failed.


Enjoy, Edwin.
