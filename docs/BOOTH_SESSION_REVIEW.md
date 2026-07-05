# MyBooth Booth Session Review

MyBooth v0.20 adds the guest session review foundation between capture and QR delivery.

## Guest flow

1. Tap **Start Photo Session**.
2. Complete the countdown and capture sequence.
3. MyBooth builds a final bordered preview.
4. Guest/operator reviews the result.
5. Choose one of:
   - **Approve + Queue Print**
   - **Retake Last Photo**
   - **Start Over**
   - **Skip printing for this session**
6. Approved sessions move to the QR gallery screen.

## Print quantity foundation

The review screen supports 1 to 6 print copies. The default comes from the event print copy setting. This is still a queue foundation; the DNP printer integration will wire this into a real print queue later.

## QR delivery rule

Guest QR links only show final bordered/composited outputs. Raw Canon captures and intermediate processing folders remain operator-only on the laptop server.
