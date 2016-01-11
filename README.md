### calculate_ipa_size.sh
Used for determining the size of an IPA-file after **Apple iConnect** processing. Input is the path to an IPA-file and an optional integer percentage which defines the compressability of the executable inside the IPA:
> calculate_ipa_size.sh path [percentage] ...

When [percentage] is unused, a percentage of 100 is used and the script essentially calculates the upper limit on the size of the post-processed IPA. To find an estimate of the compressability one has to calculate the difference in compressability of a locally built IPA and the final store size, assuming the same commpressability on everything except the executable, e.g.:

1. Get an IPA and let Apple calculate a post-processed size [A].
2. Remove the executable from within the original IPA by de-compressing it, note the size of the executable in the Payload-folder [B], removing the executable inside the Payload-folder and re-compressing the folder. Note the size of compressed assets folder [C].
3. [percentage] = (A - C) / B * 100 

*Note, no decimal percentages supported, please round the final percentage. Instead of calculating the percentage one can also approach the percentage by trial-and-error using the percentage of similar projects.*

To give a ballpark estimate on the uncompressable percentage; a Unity product I frequently calculated had a percentage of ~92.
Although a good percentage here can get you close to the actual post-processed IPA size, it is no guarantee Apple doesn't change their DRM policy and this percentage changes. A change in your source code can also influence the uncompressable percentage. **If you need to be sure, assume the worst (100% uncompressability)!**
