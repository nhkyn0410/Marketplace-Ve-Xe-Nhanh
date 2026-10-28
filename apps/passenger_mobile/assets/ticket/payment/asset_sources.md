# Payment asset sources

The five payment-method images prefixed with `payment_` were exported directly
from Figma node `1572:2031` (`Payment / methods`) through the official Figma MCP
asset endpoint. They are checked into the app so no temporary Figma URL is used
at runtime.

Bank logo files in this directory mirror the vector/brand marks shown in the
Figma bank picker. PNG sources are the VietQR bank directory
(`https://api.vietqr.io/v2/banks`) so the Flutter mock can render the original
bank marks without redrawing them.
