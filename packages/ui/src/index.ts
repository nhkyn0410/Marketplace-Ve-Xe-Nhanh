export type ButtonVariant = "primary" | "secondary";

export const buttonClassName: Record<ButtonVariant, string> = {
  primary: "inline-flex items-center justify-center font-medium",
  secondary: "inline-flex items-center justify-center font-medium"
};
