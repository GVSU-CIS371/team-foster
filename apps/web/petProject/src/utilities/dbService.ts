import { db } from "./firebase.ts";
import {doc, collection, query, where, setDoc, addDoc, getDoc, getDocs, deleteDoc, Timestamp, onSnapshot } from "firebase/firestore"
import type { WhereFilterOp } from "firebase/firestore";


export const CollectionNames = {
    Inventories: "inventories",
    InventoryItems: "inventory_items",
    Items: "items",
    PetTypes: "pet_types",
    Pets: "pets",
    ShopItems: "shop_items",
    Shops: "shops",
    Users: "users",
} as const;

export type CollectionNames = (typeof CollectionNames)[keyof typeof CollectionNames];
var listeners = new Map<string, () => void>

function updateDbTimestamp(obj: any){
    if(obj?.last_update) {
        console.log("updatedb last_update timestamp")
        return {...obj, last_update: Timestamp.now()}
    } else if (obj?.lastUpdate){
        console.log("udpatedb lastUpdate timestamp")
        return {...obj, lastUpdate: Timestamp.now()}
    } else {
        return obj
    }
}

function updateDate(obj: any){
    if(obj?.lastUpdate){
        console.log("updatedate lastUpdate date")
        return {...obj, lastUpdate: new Date()}
    } else if(obj?.last_update){
        console.log("updatedate last_update date")
        return {...obj, last_update: new Date()}
    } else {
        return obj
    }
}

async function addDocument (collectName: string, data: Object){
    try{
        updateDbTimestamp(data)

        await addDoc(collection(db, collectName), data)
        
    } catch(error){
        console.log(error)
    }
}

async function addNamedDocument(collectName: string, docName: string, data: Object){
    try{
        const docRef = doc(db, collectName, docName)
        updateDbTimestamp(data)

        await setDoc(docRef, data)

    } catch(error){
        console.log(error)
    }
}

async function getDocument (collectName: string, docName: string){
    try{
        const docRef = await doc(db, collectName, docName)
        const dSnapshot = await getDoc(docRef)
        if (dSnapshot.exists()){
            console.log(dSnapshot)
            return dSnapshot
        }
    } catch(error) {
        console.log(error)
    }
}

async function getCollection(collectName: string, filters: {[field: string]: {op:string, value:string}} = {}){
    try {
        const collect = filterCollection(collectName, filters)
        const qSnapshot = await getDocs(collect)
        return qSnapshot

    } catch (error) {
        console.log(error)
    }
}

function startDocListener(collectName: string, docName: string, onUpdate: (data: any) => void){
    const docRef = doc(db, collectName, docName)
    const listen = onSnapshot(docRef, (doc) => {
        console.log(collectName + "Doc Listener Fired")
        if(doc.exists()){
            console.log(doc.data());
            onUpdate(convertSnapDate(doc.data()))
        }
    });

    return listen
}

function startCollectionListener(collectName: string, filters: {[filed: string]: {op: string, value: string}} = {}, onUpdate: (data: any[]) => void){
    const collect = filterCollection(collectName, filters)
    const listen = onSnapshot(collect, (collection) => {
        console.log(collectName + "Collection Listener Fired")
        const docs = collection.docs.map(d => convertSnapDate(d))
        onUpdate(docs)
    })    

    return listen
}

function stopListener(key:string) {
    const stopListen = listeners.get(key)

    if(stopListen){
        stopListen();
        listeners.delete(key)
    }
}

function stopAllListeners(){
    listeners.forEach((_, name) => stopListener(name))
}

async function updateCollection(collectName: string, data: Object, filters: {[field:string]: {op:string, value:string}} = {}){
    try{
        const collect = filterCollection(collectName, filters)
        const qSnapshot = await getDocs(collect)
        updateDbTimestamp(data)

        if(qSnapshot.empty){
            await addDocument(collectName, data)
        } else {
            for (const doc of qSnapshot.docs) {
                console.log(doc)
                await setDoc(doc.ref, data)
            }
        }
    } catch (error){

    }
}


async function updateDocument(collectName: string, docName: string, data: Object){
    try {
        const docRef = doc(db, collectName, docName)
        updateDbTimestamp(data)
        await setDoc(docRef, data)

    } catch (error){
        console.log(error)
    }
}

async function deleteDocument(collectName: string, filters: {[field: string]: {op: string, value:string}} = {}){
    try {
        const collect = filterCollection(collectName, filters)
        const qSnapshot = await getDocs(collect)
        for(const doc of qSnapshot.docs){
            await deleteDoc(doc.ref)
        }
    }catch (error){

    }
}


function filterCollection(collectName: string, filters: {[field: string]: {op: string, value:string}} = {}){
    var q = query(collection(db, collectName))

    for (const [field, filter] of Object.entries(filters)){
        q = query(q, where(field, filter.op as WhereFilterOp, filter.value))
    }

    return q

}

function snapshotConverter<T>(snap: any) {
    console.log("snapshot converter")
    let obj = convertSnapDate(snap.data() as T);
    return obj;
} 

function convertSnapDate(snap: any){
    return updateDate(snap)
}

export {updateDate, updateDbTimestamp, getDocument, getCollection, updateDocument, 
        deleteDocument, addDocument, addNamedDocument, updateCollection, snapshotConverter, 
        startDocListener, startCollectionListener, stopListener, stopAllListeners}