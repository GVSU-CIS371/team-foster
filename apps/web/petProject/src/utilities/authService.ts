import {auth} from "./firebase";
import { createUserWithEmailAndPassword, signInWithEmailAndPassword} from "firebase/auth";

const registerUser = (email: string, password: string) => {
    console.log("registerattempt")
    return createUserWithEmailAndPassword(auth, email, password)
        .then((userCredential) => {
            // Signed in
            const user = userCredential.user;
            console.log("logged in")
            return user
            // ...
        })
        .catch((error) => {
            console.log("login error")
            console.log(error.code)
            console.log(error.message)

            return null
            // ..
        });
}

const loginUser = (email: string, password: string)  => {
    console.log("loginattempt")

    return signInWithEmailAndPassword(auth, email, password)
        .then((userCredential) => {
            // Signed in
            const user = userCredential.user;
            console.log(user)
            return user
            // ...
        })
        .catch(async (error) => {
            console.log("login error")
            console.log(error.code)
            console.log(error.message)
            console.log(email, password)

            var rval = null

            if (error.code === "auth/invalid-credential"){
                console.log("invalid credential")
                rval = await registerUser(email, password)
            }

            return rval

  
        });
}


export {registerUser, loginUser}