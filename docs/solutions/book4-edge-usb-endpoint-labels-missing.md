# Solution: Book4 Edge DTS referenced missing USB labels

Related problem:
[docs/problems/2026-05-15-book4-edge-usb-endpoint-labels-missing.md](../problems/2026-05-15-book4-edge-usb-endpoint-labels-missing.md)

## What failed

The rebased Book4 Edge `dtsi` referenced nonexistent `&usb_1_ss0_dwc3` and
`&usb_1_ss1_dwc3` labels during DTB compilation.

## What worked

Compared the file against current upstream `hamoa`-based X1 laptop DTS
files and changed those references to `&usb_1_ss0` and `&usb_1_ss1`, while
leaving the endpoint references on `&usb_1_ss0_dwc3_hs` and
`&usb_1_ss1_dwc3_hs`.

## Why it worked

Current upstream sets `dr_mode` on the USB controller nodes themselves, not
on separate `dwc3` labels for these ports. Matching that pattern made the
Samsung DTS compile cleanly.

## All commands run

```text
rg -n "usb_1_ss0|usb_1_ss1|dwc3_hs" arch/arm64/boot/dts/qcom
git add arch/arm64/boot/dts/qcom/x1-samsung-galaxy-book4-edge.dtsi
git commit -m "arm64: dts: qcom: fix Book4 Edge USB node labels"
```
