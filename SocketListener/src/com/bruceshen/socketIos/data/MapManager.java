package com.bruceshen.socketIos.data;

import java.util.concurrent.ConcurrentHashMap;

/**
 * Created by zekunshen on 6/3/16.
 */
public abstract class MapManager<K, V> {

    ConcurrentHashMap<K, V> map;

    abstract void printData();

    boolean isEmpty() {
        return map.isEmpty();
    }

    boolean containsKey(K key) {
        return map.containsKey(key);
    }

    boolean containsValue(V value) {
        return map.containsValue(value);
    }

    boolean contains(V value) {
        return map.contains(value);
    }

    void put(K key, V value) {
        map.put(key, value);
    }

    void clear() {
        map.clear();
    }



}
