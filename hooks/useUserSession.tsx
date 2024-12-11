import { useEffect, useState } from "react";
import { userSession } from "@/lib/Wallet";

export const useUserSession = () => {
  const [isSignedIn, setIsSignedIn] = useState(userSession.isUserSignedIn());
  useEffect(() => {
    const authResponse = userSession.loadUserData();
    if (authResponse) {
      setIsSignedIn(true);
    }
  }, []);
  return { isSignedIn };
};