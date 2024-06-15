
(function(l, r) { if (!l || l.getElementById('livereloadscript')) return; r = l.createElement('script'); r.async = 1; r.src = '//' + (self.location.host || 'localhost').split(':')[0] + ':35729/livereload.js?snipver=1'; r.id = 'livereloadscript'; l.getElementsByTagName('head')[0].appendChild(r) })(self.document);
var app = (function () {
    'use strict';

    function noop() { }
    function assign(tar, src) {
        // @ts-ignore
        for (const k in src)
            tar[k] = src[k];
        return tar;
    }
    function add_location(element, file, line, column, char) {
        element.__svelte_meta = {
            loc: { file, line, column, char }
        };
    }
    function run(fn) {
        return fn();
    }
    function blank_object() {
        return Object.create(null);
    }
    function run_all(fns) {
        fns.forEach(run);
    }
    function is_function(thing) {
        return typeof thing === 'function';
    }
    function safe_not_equal(a, b) {
        return a != a ? b == b : a !== b || ((a && typeof a === 'object') || typeof a === 'function');
    }
    let src_url_equal_anchor;
    function src_url_equal(element_src, url) {
        if (!src_url_equal_anchor) {
            src_url_equal_anchor = document.createElement('a');
        }
        src_url_equal_anchor.href = url;
        return element_src === src_url_equal_anchor.href;
    }
    function is_empty(obj) {
        return Object.keys(obj).length === 0;
    }
    function validate_store(store, name) {
        if (store != null && typeof store.subscribe !== 'function') {
            throw new Error(`'${name}' is not a store with a 'subscribe' method`);
        }
    }
    function subscribe(store, ...callbacks) {
        if (store == null) {
            return noop;
        }
        const unsub = store.subscribe(...callbacks);
        return unsub.unsubscribe ? () => unsub.unsubscribe() : unsub;
    }
    function component_subscribe(component, store, callback) {
        component.$$.on_destroy.push(subscribe(store, callback));
    }
    function create_slot(definition, ctx, $$scope, fn) {
        if (definition) {
            const slot_ctx = get_slot_context(definition, ctx, $$scope, fn);
            return definition[0](slot_ctx);
        }
    }
    function get_slot_context(definition, ctx, $$scope, fn) {
        return definition[1] && fn
            ? assign($$scope.ctx.slice(), definition[1](fn(ctx)))
            : $$scope.ctx;
    }
    function get_slot_changes(definition, $$scope, dirty, fn) {
        if (definition[2] && fn) {
            const lets = definition[2](fn(dirty));
            if ($$scope.dirty === undefined) {
                return lets;
            }
            if (typeof lets === 'object') {
                const merged = [];
                const len = Math.max($$scope.dirty.length, lets.length);
                for (let i = 0; i < len; i += 1) {
                    merged[i] = $$scope.dirty[i] | lets[i];
                }
                return merged;
            }
            return $$scope.dirty | lets;
        }
        return $$scope.dirty;
    }
    function update_slot_base(slot, slot_definition, ctx, $$scope, slot_changes, get_slot_context_fn) {
        if (slot_changes) {
            const slot_context = get_slot_context(slot_definition, ctx, $$scope, get_slot_context_fn);
            slot.p(slot_context, slot_changes);
        }
    }
    function get_all_dirty_from_scope($$scope) {
        if ($$scope.ctx.length > 32) {
            const dirty = [];
            const length = $$scope.ctx.length / 32;
            for (let i = 0; i < length; i++) {
                dirty[i] = -1;
            }
            return dirty;
        }
        return -1;
    }

    const globals = (typeof window !== 'undefined'
        ? window
        : typeof globalThis !== 'undefined'
            ? globalThis
            : global);
    function append(target, node) {
        target.appendChild(node);
    }
    function insert(target, node, anchor) {
        target.insertBefore(node, anchor || null);
    }
    function detach(node) {
        if (node.parentNode) {
            node.parentNode.removeChild(node);
        }
    }
    function destroy_each(iterations, detaching) {
        for (let i = 0; i < iterations.length; i += 1) {
            if (iterations[i])
                iterations[i].d(detaching);
        }
    }
    function element(name) {
        return document.createElement(name);
    }
    function text(data) {
        return document.createTextNode(data);
    }
    function space() {
        return text(' ');
    }
    function empty() {
        return text('');
    }
    function listen(node, event, handler, options) {
        node.addEventListener(event, handler, options);
        return () => node.removeEventListener(event, handler, options);
    }
    function prevent_default(fn) {
        return function (event) {
            event.preventDefault();
            // @ts-ignore
            return fn.call(this, event);
        };
    }
    function attr(node, attribute, value) {
        if (value == null)
            node.removeAttribute(attribute);
        else if (node.getAttribute(attribute) !== value)
            node.setAttribute(attribute, value);
    }
    function to_number(value) {
        return value === '' ? null : +value;
    }
    function children(element) {
        return Array.from(element.childNodes);
    }
    function set_input_value(input, value) {
        input.value = value == null ? '' : value;
    }
    function set_style(node, key, value, important) {
        if (value == null) {
            node.style.removeProperty(key);
        }
        else {
            node.style.setProperty(key, value, important ? 'important' : '');
        }
    }
    function toggle_class(element, name, toggle) {
        element.classList[toggle ? 'add' : 'remove'](name);
    }
    function custom_event(type, detail, { bubbles = false, cancelable = false } = {}) {
        const e = document.createEvent('CustomEvent');
        e.initCustomEvent(type, bubbles, cancelable, detail);
        return e;
    }

    let current_component;
    function set_current_component(component) {
        current_component = component;
    }
    function get_current_component() {
        if (!current_component)
            throw new Error('Function called outside component initialization');
        return current_component;
    }
    /**
     * The `onMount` function schedules a callback to run as soon as the component has been mounted to the DOM.
     * It must be called during the component's initialisation (but doesn't need to live *inside* the component;
     * it can be called from an external module).
     *
     * `onMount` does not run inside a [server-side component](/docs#run-time-server-side-component-api).
     *
     * https://svelte.dev/docs#run-time-svelte-onmount
     */
    function onMount(fn) {
        get_current_component().$$.on_mount.push(fn);
    }
    /**
     * Schedules a callback to run immediately before the component is unmounted.
     *
     * Out of `onMount`, `beforeUpdate`, `afterUpdate` and `onDestroy`, this is the
     * only one that runs inside a server-side component.
     *
     * https://svelte.dev/docs#run-time-svelte-ondestroy
     */
    function onDestroy(fn) {
        get_current_component().$$.on_destroy.push(fn);
    }

    const dirty_components = [];
    const binding_callbacks = [];
    let render_callbacks = [];
    const flush_callbacks = [];
    const resolved_promise = /* @__PURE__ */ Promise.resolve();
    let update_scheduled = false;
    function schedule_update() {
        if (!update_scheduled) {
            update_scheduled = true;
            resolved_promise.then(flush);
        }
    }
    function add_render_callback(fn) {
        render_callbacks.push(fn);
    }
    // flush() calls callbacks in this order:
    // 1. All beforeUpdate callbacks, in order: parents before children
    // 2. All bind:this callbacks, in reverse order: children before parents.
    // 3. All afterUpdate callbacks, in order: parents before children. EXCEPT
    //    for afterUpdates called during the initial onMount, which are called in
    //    reverse order: children before parents.
    // Since callbacks might update component values, which could trigger another
    // call to flush(), the following steps guard against this:
    // 1. During beforeUpdate, any updated components will be added to the
    //    dirty_components array and will cause a reentrant call to flush(). Because
    //    the flush index is kept outside the function, the reentrant call will pick
    //    up where the earlier call left off and go through all dirty components. The
    //    current_component value is saved and restored so that the reentrant call will
    //    not interfere with the "parent" flush() call.
    // 2. bind:this callbacks cannot trigger new flush() calls.
    // 3. During afterUpdate, any updated components will NOT have their afterUpdate
    //    callback called a second time; the seen_callbacks set, outside the flush()
    //    function, guarantees this behavior.
    const seen_callbacks = new Set();
    let flushidx = 0; // Do *not* move this inside the flush() function
    function flush() {
        // Do not reenter flush while dirty components are updated, as this can
        // result in an infinite loop. Instead, let the inner flush handle it.
        // Reentrancy is ok afterwards for bindings etc.
        if (flushidx !== 0) {
            return;
        }
        const saved_component = current_component;
        do {
            // first, call beforeUpdate functions
            // and update components
            try {
                while (flushidx < dirty_components.length) {
                    const component = dirty_components[flushidx];
                    flushidx++;
                    set_current_component(component);
                    update(component.$$);
                }
            }
            catch (e) {
                // reset dirty state to not end up in a deadlocked state and then rethrow
                dirty_components.length = 0;
                flushidx = 0;
                throw e;
            }
            set_current_component(null);
            dirty_components.length = 0;
            flushidx = 0;
            while (binding_callbacks.length)
                binding_callbacks.pop()();
            // then, once components are updated, call
            // afterUpdate functions. This may cause
            // subsequent updates...
            for (let i = 0; i < render_callbacks.length; i += 1) {
                const callback = render_callbacks[i];
                if (!seen_callbacks.has(callback)) {
                    // ...so guard against infinite loops
                    seen_callbacks.add(callback);
                    callback();
                }
            }
            render_callbacks.length = 0;
        } while (dirty_components.length);
        while (flush_callbacks.length) {
            flush_callbacks.pop()();
        }
        update_scheduled = false;
        seen_callbacks.clear();
        set_current_component(saved_component);
    }
    function update($$) {
        if ($$.fragment !== null) {
            $$.update();
            run_all($$.before_update);
            const dirty = $$.dirty;
            $$.dirty = [-1];
            $$.fragment && $$.fragment.p($$.ctx, dirty);
            $$.after_update.forEach(add_render_callback);
        }
    }
    /**
     * Useful for example to execute remaining `afterUpdate` callbacks before executing `destroy`.
     */
    function flush_render_callbacks(fns) {
        const filtered = [];
        const targets = [];
        render_callbacks.forEach((c) => fns.indexOf(c) === -1 ? filtered.push(c) : targets.push(c));
        targets.forEach((c) => c());
        render_callbacks = filtered;
    }
    const outroing = new Set();
    let outros;
    function group_outros() {
        outros = {
            r: 0,
            c: [],
            p: outros // parent group
        };
    }
    function check_outros() {
        if (!outros.r) {
            run_all(outros.c);
        }
        outros = outros.p;
    }
    function transition_in(block, local) {
        if (block && block.i) {
            outroing.delete(block);
            block.i(local);
        }
    }
    function transition_out(block, local, detach, callback) {
        if (block && block.o) {
            if (outroing.has(block))
                return;
            outroing.add(block);
            outros.c.push(() => {
                outroing.delete(block);
                if (callback) {
                    if (detach)
                        block.d(1);
                    callback();
                }
            });
            block.o(local);
        }
        else if (callback) {
            callback();
        }
    }
    function outro_and_destroy_block(block, lookup) {
        transition_out(block, 1, 1, () => {
            lookup.delete(block.key);
        });
    }
    function update_keyed_each(old_blocks, dirty, get_key, dynamic, ctx, list, lookup, node, destroy, create_each_block, next, get_context) {
        let o = old_blocks.length;
        let n = list.length;
        let i = o;
        const old_indexes = {};
        while (i--)
            old_indexes[old_blocks[i].key] = i;
        const new_blocks = [];
        const new_lookup = new Map();
        const deltas = new Map();
        const updates = [];
        i = n;
        while (i--) {
            const child_ctx = get_context(ctx, list, i);
            const key = get_key(child_ctx);
            let block = lookup.get(key);
            if (!block) {
                block = create_each_block(key, child_ctx);
                block.c();
            }
            else if (dynamic) {
                // defer updates until all the DOM shuffling is done
                updates.push(() => block.p(child_ctx, dirty));
            }
            new_lookup.set(key, new_blocks[i] = block);
            if (key in old_indexes)
                deltas.set(key, Math.abs(i - old_indexes[key]));
        }
        const will_move = new Set();
        const did_move = new Set();
        function insert(block) {
            transition_in(block, 1);
            block.m(node, next);
            lookup.set(block.key, block);
            next = block.first;
            n--;
        }
        while (o && n) {
            const new_block = new_blocks[n - 1];
            const old_block = old_blocks[o - 1];
            const new_key = new_block.key;
            const old_key = old_block.key;
            if (new_block === old_block) {
                // do nothing
                next = new_block.first;
                o--;
                n--;
            }
            else if (!new_lookup.has(old_key)) {
                // remove old block
                destroy(old_block, lookup);
                o--;
            }
            else if (!lookup.has(new_key) || will_move.has(new_key)) {
                insert(new_block);
            }
            else if (did_move.has(old_key)) {
                o--;
            }
            else if (deltas.get(new_key) > deltas.get(old_key)) {
                did_move.add(new_key);
                insert(new_block);
            }
            else {
                will_move.add(old_key);
                o--;
            }
        }
        while (o--) {
            const old_block = old_blocks[o];
            if (!new_lookup.has(old_block.key))
                destroy(old_block, lookup);
        }
        while (n)
            insert(new_blocks[n - 1]);
        run_all(updates);
        return new_blocks;
    }
    function validate_each_keys(ctx, list, get_context, get_key) {
        const keys = new Set();
        for (let i = 0; i < list.length; i++) {
            const key = get_key(get_context(ctx, list, i));
            if (keys.has(key)) {
                throw new Error('Cannot have duplicate keys in a keyed each');
            }
            keys.add(key);
        }
    }
    function create_component(block) {
        block && block.c();
    }
    function mount_component(component, target, anchor, customElement) {
        const { fragment, after_update } = component.$$;
        fragment && fragment.m(target, anchor);
        if (!customElement) {
            // onMount happens before the initial afterUpdate
            add_render_callback(() => {
                const new_on_destroy = component.$$.on_mount.map(run).filter(is_function);
                // if the component was destroyed immediately
                // it will update the `$$.on_destroy` reference to `null`.
                // the destructured on_destroy may still reference to the old array
                if (component.$$.on_destroy) {
                    component.$$.on_destroy.push(...new_on_destroy);
                }
                else {
                    // Edge case - component was destroyed immediately,
                    // most likely as a result of a binding initialising
                    run_all(new_on_destroy);
                }
                component.$$.on_mount = [];
            });
        }
        after_update.forEach(add_render_callback);
    }
    function destroy_component(component, detaching) {
        const $$ = component.$$;
        if ($$.fragment !== null) {
            flush_render_callbacks($$.after_update);
            run_all($$.on_destroy);
            $$.fragment && $$.fragment.d(detaching);
            // TODO null out other refs, including component.$$ (but need to
            // preserve final state?)
            $$.on_destroy = $$.fragment = null;
            $$.ctx = [];
        }
    }
    function make_dirty(component, i) {
        if (component.$$.dirty[0] === -1) {
            dirty_components.push(component);
            schedule_update();
            component.$$.dirty.fill(0);
        }
        component.$$.dirty[(i / 31) | 0] |= (1 << (i % 31));
    }
    function init(component, options, instance, create_fragment, not_equal, props, append_styles, dirty = [-1]) {
        const parent_component = current_component;
        set_current_component(component);
        const $$ = component.$$ = {
            fragment: null,
            ctx: [],
            // state
            props,
            update: noop,
            not_equal,
            bound: blank_object(),
            // lifecycle
            on_mount: [],
            on_destroy: [],
            on_disconnect: [],
            before_update: [],
            after_update: [],
            context: new Map(options.context || (parent_component ? parent_component.$$.context : [])),
            // everything else
            callbacks: blank_object(),
            dirty,
            skip_bound: false,
            root: options.target || parent_component.$$.root
        };
        append_styles && append_styles($$.root);
        let ready = false;
        $$.ctx = instance
            ? instance(component, options.props || {}, (i, ret, ...rest) => {
                const value = rest.length ? rest[0] : ret;
                if ($$.ctx && not_equal($$.ctx[i], $$.ctx[i] = value)) {
                    if (!$$.skip_bound && $$.bound[i])
                        $$.bound[i](value);
                    if (ready)
                        make_dirty(component, i);
                }
                return ret;
            })
            : [];
        $$.update();
        ready = true;
        run_all($$.before_update);
        // `false` as a special case of no DOM component
        $$.fragment = create_fragment ? create_fragment($$.ctx) : false;
        if (options.target) {
            if (options.hydrate) {
                const nodes = children(options.target);
                // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
                $$.fragment && $$.fragment.l(nodes);
                nodes.forEach(detach);
            }
            else {
                // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
                $$.fragment && $$.fragment.c();
            }
            if (options.intro)
                transition_in(component.$$.fragment);
            mount_component(component, options.target, options.anchor, options.customElement);
            flush();
        }
        set_current_component(parent_component);
    }
    /**
     * Base class for Svelte components. Used when dev=false.
     */
    class SvelteComponent {
        $destroy() {
            destroy_component(this, 1);
            this.$destroy = noop;
        }
        $on(type, callback) {
            if (!is_function(callback)) {
                return noop;
            }
            const callbacks = (this.$$.callbacks[type] || (this.$$.callbacks[type] = []));
            callbacks.push(callback);
            return () => {
                const index = callbacks.indexOf(callback);
                if (index !== -1)
                    callbacks.splice(index, 1);
            };
        }
        $set($$props) {
            if (this.$$set && !is_empty($$props)) {
                this.$$.skip_bound = true;
                this.$$set($$props);
                this.$$.skip_bound = false;
            }
        }
    }

    function dispatch_dev(type, detail) {
        document.dispatchEvent(custom_event(type, Object.assign({ version: '3.59.2' }, detail), { bubbles: true }));
    }
    function append_dev(target, node) {
        dispatch_dev('SvelteDOMInsert', { target, node });
        append(target, node);
    }
    function insert_dev(target, node, anchor) {
        dispatch_dev('SvelteDOMInsert', { target, node, anchor });
        insert(target, node, anchor);
    }
    function detach_dev(node) {
        dispatch_dev('SvelteDOMRemove', { node });
        detach(node);
    }
    function listen_dev(node, event, handler, options, has_prevent_default, has_stop_propagation, has_stop_immediate_propagation) {
        const modifiers = options === true ? ['capture'] : options ? Array.from(Object.keys(options)) : [];
        if (has_prevent_default)
            modifiers.push('preventDefault');
        if (has_stop_propagation)
            modifiers.push('stopPropagation');
        if (has_stop_immediate_propagation)
            modifiers.push('stopImmediatePropagation');
        dispatch_dev('SvelteDOMAddEventListener', { node, event, handler, modifiers });
        const dispose = listen(node, event, handler, options);
        return () => {
            dispatch_dev('SvelteDOMRemoveEventListener', { node, event, handler, modifiers });
            dispose();
        };
    }
    function attr_dev(node, attribute, value) {
        attr(node, attribute, value);
        if (value == null)
            dispatch_dev('SvelteDOMRemoveAttribute', { node, attribute });
        else
            dispatch_dev('SvelteDOMSetAttribute', { node, attribute, value });
    }
    function set_data_dev(text, data) {
        data = '' + data;
        if (text.data === data)
            return;
        dispatch_dev('SvelteDOMSetData', { node: text, data });
        text.data = data;
    }
    function validate_each_argument(arg) {
        if (typeof arg !== 'string' && !(arg && typeof arg === 'object' && 'length' in arg)) {
            let msg = '{#each} only iterates over array-like objects.';
            if (typeof Symbol === 'function' && arg && Symbol.iterator in arg) {
                msg += ' You can use a spread to convert this iterable into an array.';
            }
            throw new Error(msg);
        }
    }
    function validate_slots(name, slot, keys) {
        for (const slot_key of Object.keys(slot)) {
            if (!~keys.indexOf(slot_key)) {
                console.warn(`<${name}> received an unexpected slot "${slot_key}".`);
            }
        }
    }
    /**
     * Base class for Svelte components with some minor dev-enhancements. Used when dev=true.
     */
    class SvelteComponentDev extends SvelteComponent {
        constructor(options) {
            if (!options || (!options.target && !options.$$inline)) {
                throw new Error("'target' is a required option");
            }
            super();
        }
        $destroy() {
            super.$destroy();
            this.$destroy = () => {
                console.warn('Component was already destroyed'); // eslint-disable-line no-console
            };
        }
        $capture_state() { }
        $inject_state() { }
    }

    /**
    * @param eventName - The endpoint eventname to target
    * @param data - Data you wish to send in the NUI Callback
    * @return returnData - A promise for the data sent back by the NuiCallbacks CB argument
    */
    async function fetchNui(eventName, data = {}) {
        const options = {
            method: "post",
            headers: {
                "Content-Type": "application/json; charset=UTF-8",
            },
            body: JSON.stringify(data),
        };
        const resp = await fetch(`https://aj-banking/${eventName}`, options);
        return await resp.json();
    }

    const subscriber_queue = [];
    /**
     * Create a `Writable` store that allows both updating and reading by subscription.
     * @param {*=}value initial value
     * @param {StartStopNotifier=} start
     */
    function writable(value, start = noop) {
        let stop;
        const subscribers = new Set();
        function set(new_value) {
            if (safe_not_equal(value, new_value)) {
                value = new_value;
                if (stop) { // store is ready
                    const run_queue = !subscriber_queue.length;
                    for (const subscriber of subscribers) {
                        subscriber[1]();
                        subscriber_queue.push(subscriber, value);
                    }
                    if (run_queue) {
                        for (let i = 0; i < subscriber_queue.length; i += 2) {
                            subscriber_queue[i][0](subscriber_queue[i + 1]);
                        }
                        subscriber_queue.length = 0;
                    }
                }
            }
        }
        function update(fn) {
            set(fn(value));
        }
        function subscribe(run, invalidate = noop) {
            const subscriber = [run, invalidate];
            subscribers.add(subscriber);
            if (subscribers.size === 1) {
                stop = start(set) || noop;
            }
            run(value);
            return () => {
                subscribers.delete(subscriber);
                if (subscribers.size === 0 && stop) {
                    stop();
                    stop = null;
                }
            };
        }
        return { set, update, subscribe };
    }

    const visibility = writable(false);
    const loading = writable(false);
    const notify = writable("");
    let activeAccount = writable(null);
    const atm = writable(false);
    const currency = writable("USD");
    let popupDetails = writable({
        account: {
            id: undefined,
            type: undefined
        },
        actionType: "",
    });
    let orderDetail = writable({
        status: false,
        pin: 0,
    });
    const cardsDetail = writable({
        status: false,
        cards: []
    });
    const accountsVisible = writable({
        status: false
    });
    const accounts = writable();
    const itemsDetails = writable({
        status: false,
        items: []
    });
    const pinDetails = writable({
        status: false,
        cardNumber: ''
    });
    const translations = writable();

    function useNuiEvent(action, handler) {
        const eventListener = (event) => {
            event.data.action === action && handler(event.data);
        };
        onMount(() => window.addEventListener("message", eventListener));
        onDestroy(() => window.removeEventListener("message", eventListener));
    }

    /* src\providers\VisibilityProvider.svelte generated by Svelte v3.59.2 */

    const { Object: Object_1$1 } = globals;

    // (72:0) {#if isVisible}
    function create_if_block$7(ctx) {
    	let current;
    	const default_slot_template = /*#slots*/ ctx[2].default;
    	const default_slot = create_slot(default_slot_template, ctx, /*$$scope*/ ctx[1], null);

    	const block = {
    		c: function create() {
    			if (default_slot) default_slot.c();
    		},
    		m: function mount(target, anchor) {
    			if (default_slot) {
    				default_slot.m(target, anchor);
    			}

    			current = true;
    		},
    		p: function update(ctx, dirty) {
    			if (default_slot) {
    				if (default_slot.p && (!current || dirty & /*$$scope*/ 2)) {
    					update_slot_base(
    						default_slot,
    						default_slot_template,
    						ctx,
    						/*$$scope*/ ctx[1],
    						!current
    						? get_all_dirty_from_scope(/*$$scope*/ ctx[1])
    						: get_slot_changes(default_slot_template, /*$$scope*/ ctx[1], dirty, null),
    						null
    					);
    				}
    			}
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(default_slot, local);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(default_slot, local);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			if (default_slot) default_slot.d(detaching);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block$7.name,
    		type: "if",
    		source: "(72:0) {#if isVisible}",
    		ctx
    	});

    	return block;
    }

    function create_fragment$d(ctx) {
    	let if_block_anchor;
    	let current;
    	let if_block = /*isVisible*/ ctx[0] && create_if_block$7(ctx);

    	const block = {
    		c: function create() {
    			if (if_block) if_block.c();
    			if_block_anchor = empty();
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			if (if_block) if_block.m(target, anchor);
    			insert_dev(target, if_block_anchor, anchor);
    			current = true;
    		},
    		p: function update(ctx, [dirty]) {
    			if (/*isVisible*/ ctx[0]) {
    				if (if_block) {
    					if_block.p(ctx, dirty);

    					if (dirty & /*isVisible*/ 1) {
    						transition_in(if_block, 1);
    					}
    				} else {
    					if_block = create_if_block$7(ctx);
    					if_block.c();
    					transition_in(if_block, 1);
    					if_block.m(if_block_anchor.parentNode, if_block_anchor);
    				}
    			} else if (if_block) {
    				group_outros();

    				transition_out(if_block, 1, 1, () => {
    					if_block = null;
    				});

    				check_outros();
    			}
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(if_block);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(if_block);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			if (if_block) if_block.d(detaching);
    			if (detaching) detach_dev(if_block_anchor);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment$d.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function instance$d($$self, $$props, $$invalidate) {
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('VisibilityProvider', slots, ['default']);
    	let isVisible;

    	visibility.subscribe(visible => {
    		$$invalidate(0, isVisible = visible);
    	});

    	useNuiEvent('setVisible', data => {
    		accountsVisible.set({ status: true });
    		accounts.set(data.accounts);
    		activeAccount.update(() => data.accounts[0].id);
    		visibility.set(data.status);
    		loading.set(data.loading);
    		atm.set(data.atm);
    	});

    	useNuiEvent('openCardUI', data => {
    		visibility.set(data.status);
    		itemsDetails.set({ status: true, items: data.items });
    		loading.set(data.loading);
    	});

    	useNuiEvent('setLoading', data => {
    		loading.set(data.status);
    	});

    	useNuiEvent('notify', data => {
    		notify.set(data.status);

    		setTimeout(
    			() => {
    				notify.set("");
    			},
    			3500
    		);
    	});

    	useNuiEvent('updateLocale', data => {
    		translations.set(data.translations);
    		currency.set(data.currency);
    	});

    	onMount(() => {
    		const keyHandler = e => {
    			if (isVisible && ['Escape'].includes(e.code)) {
    				fetchNui('closeInterface');
    				visibility.set(false);
    				popupDetails.update(val => Object.assign(Object.assign({}, val), { actionType: "" }));
    				orderDetail.update(() => ({ status: false, pin: 0 }));
    				accountsVisible.update(() => ({ status: false }));
    				cardsDetail.update(() => ({ status: false, cards: [] }));
    				itemsDetails.update(() => ({ status: false, items: [] }));
    				pinDetails.update(() => ({ status: false, cardNumber: 0 }));
    			}
    		};

    		window.addEventListener('keydown', keyHandler);
    		return () => window.removeEventListener('keydown', keyHandler);
    	});

    	const writable_props = [];

    	Object_1$1.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console.warn(`<VisibilityProvider> was created with unknown prop '${key}'`);
    	});

    	$$self.$$set = $$props => {
    		if ('$$scope' in $$props) $$invalidate(1, $$scope = $$props.$$scope);
    	};

    	$$self.$capture_state = () => ({
    		fetchNui,
    		onMount,
    		visibility,
    		accounts,
    		activeAccount,
    		loading,
    		notify,
    		popupDetails,
    		atm,
    		translations,
    		currency,
    		orderDetail,
    		cardsDetail,
    		accountsVisible,
    		itemsDetails,
    		pinDetails,
    		useNuiEvent,
    		isVisible
    	});

    	$$self.$inject_state = $$props => {
    		if ('isVisible' in $$props) $$invalidate(0, isVisible = $$props.isVisible);
    	};

    	if ($$props && "$$inject" in $$props) {
    		$$self.$inject_state($$props.$$inject);
    	}

    	return [isVisible, $$scope, slots];
    }

    class VisibilityProvider extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance$d, create_fragment$d, safe_not_equal, {});

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "VisibilityProvider",
    			options,
    			id: create_fragment$d.name
    		});
    	}
    }

    const isEnvBrowser = () => !window.invokeNative;
    let activeCurrency;
    currency.subscribe((value) => {
        activeCurrency = value;
    });
    function formatMoney(number) {
        return number.toLocaleString('en-US', { style: 'currency', currency: activeCurrency });
    }

    /**
     * Emulates dispatching an event using SendNuiMessage in the lua scripts.
     * This is used when developing in browser
     *
     * @param events - The event you want to cover
     * @param timer - How long until it should trigger (ms)
     */
    const debugData = (events, timer = 1000) => {
        if (isEnvBrowser()) {
            for (const event of events) {
                setTimeout(() => {
                    window.dispatchEvent(new MessageEvent("message", {
                        data: {
                            action: event.action,
                            data: event.data,
                        },
                    }));
                }, timer);
            }
        }
    };

    /* src\components\Accounts\AccountListItem.svelte generated by Svelte v3.59.2 */
    const file$c = "src\\components\\Accounts\\AccountListItem.svelte";

    // (42:8) {:else}
    function create_else_block_1$2(ctx) {
    	let t_value = /*$translations*/ ctx[2].frozen + "";
    	let t;

    	const block = {
    		c: function create() {
    			t = text(t_value);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, t, anchor);
    		},
    		p: function update(ctx, dirty) {
    			if (dirty & /*$translations*/ 4 && t_value !== (t_value = /*$translations*/ ctx[2].frozen + "")) set_data_dev(t, t_value);
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(t);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_else_block_1$2.name,
    		type: "else",
    		source: "(42:8) {:else}",
    		ctx
    	});

    	return block;
    }

    // (34:8) {#if !account.isFrozen}
    function create_if_block$6(ctx) {
    	let t0;
    	let button0;
    	let t1_value = /*$translations*/ ctx[2].withdraw_but + "";
    	let t1;
    	let t2;
    	let button1;
    	let t3_value = /*$translations*/ ctx[2].transfer_but + "";
    	let t3;
    	let mounted;
    	let dispose;

    	function select_block_type_1(ctx, dirty) {
    		if (!/*isAtm*/ ctx[1]) return create_if_block_1$3;
    		return create_else_block$4;
    	}

    	let current_block_type = select_block_type_1(ctx);
    	let if_block = current_block_type(ctx);

    	const block = {
    		c: function create() {
    			if_block.c();
    			t0 = space();
    			button0 = element("button");
    			t1 = text(t1_value);
    			t2 = space();
    			button1 = element("button");
    			t3 = text(t3_value);
    			attr_dev(button0, "class", "btn btn-red svelte-1tbdaxv");
    			add_location(button0, file$c, 39, 12, 1397);
    			attr_dev(button1, "class", "btn btn-orange svelte-1tbdaxv");
    			add_location(button1, file$c, 40, 12, 1529);
    		},
    		m: function mount(target, anchor) {
    			if_block.m(target, anchor);
    			insert_dev(target, t0, anchor);
    			insert_dev(target, button0, anchor);
    			append_dev(button0, t1);
    			insert_dev(target, t2, anchor);
    			insert_dev(target, button1, anchor);
    			append_dev(button1, t3);

    			if (!mounted) {
    				dispose = [
    					listen_dev(button0, "click", /*click_handler_2*/ ctx[7], false, false, false, false),
    					listen_dev(button1, "click", /*click_handler_3*/ ctx[8], false, false, false, false)
    				];

    				mounted = true;
    			}
    		},
    		p: function update(ctx, dirty) {
    			if (current_block_type === (current_block_type = select_block_type_1(ctx)) && if_block) {
    				if_block.p(ctx, dirty);
    			} else {
    				if_block.d(1);
    				if_block = current_block_type(ctx);

    				if (if_block) {
    					if_block.c();
    					if_block.m(t0.parentNode, t0);
    				}
    			}

    			if (dirty & /*$translations*/ 4 && t1_value !== (t1_value = /*$translations*/ ctx[2].withdraw_but + "")) set_data_dev(t1, t1_value);
    			if (dirty & /*$translations*/ 4 && t3_value !== (t3_value = /*$translations*/ ctx[2].transfer_but + "")) set_data_dev(t3, t3_value);
    		},
    		d: function destroy(detaching) {
    			if_block.d(detaching);
    			if (detaching) detach_dev(t0);
    			if (detaching) detach_dev(button0);
    			if (detaching) detach_dev(t2);
    			if (detaching) detach_dev(button1);
    			mounted = false;
    			run_all(dispose);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block$6.name,
    		type: "if",
    		source: "(34:8) {#if !account.isFrozen}",
    		ctx
    	});

    	return block;
    }

    // (37:12) {:else}
    function create_else_block$4(ctx) {
    	let button;
    	let t_value = /*$translations*/ ctx[2].deposit_but + "";
    	let t;
    	let mounted;
    	let dispose;

    	const block = {
    		c: function create() {
    			button = element("button");
    			t = text(t_value);
    			button.disabled = true;
    			attr_dev(button, "class", "btn btn-grey svelte-1tbdaxv");
    			add_location(button, file$c, 37, 16, 1239);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, button, anchor);
    			append_dev(button, t);

    			if (!mounted) {
    				dispose = listen_dev(button, "click", /*click_handler_1*/ ctx[6], false, false, false, false);
    				mounted = true;
    			}
    		},
    		p: function update(ctx, dirty) {
    			if (dirty & /*$translations*/ 4 && t_value !== (t_value = /*$translations*/ ctx[2].deposit_but + "")) set_data_dev(t, t_value);
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(button);
    			mounted = false;
    			dispose();
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_else_block$4.name,
    		type: "else",
    		source: "(37:12) {:else}",
    		ctx
    	});

    	return block;
    }

    // (35:12) {#if !isAtm}
    function create_if_block_1$3(ctx) {
    	let button;
    	let t_value = /*$translations*/ ctx[2].deposit_but + "";
    	let t;
    	let mounted;
    	let dispose;

    	const block = {
    		c: function create() {
    			button = element("button");
    			t = text(t_value);
    			attr_dev(button, "class", "btn btn-green svelte-1tbdaxv");
    			add_location(button, file$c, 35, 16, 1083);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, button, anchor);
    			append_dev(button, t);

    			if (!mounted) {
    				dispose = listen_dev(button, "click", /*click_handler*/ ctx[5], false, false, false, false);
    				mounted = true;
    			}
    		},
    		p: function update(ctx, dirty) {
    			if (dirty & /*$translations*/ 4 && t_value !== (t_value = /*$translations*/ ctx[2].deposit_but + "")) set_data_dev(t, t_value);
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(button);
    			mounted = false;
    			dispose();
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block_1$3.name,
    		type: "if",
    		source: "(35:12) {#if !isAtm}",
    		ctx
    	});

    	return block;
    }

    function create_fragment$c(ctx) {
    	let section;
    	let h4;
    	let t0_value = /*account*/ ctx[0].type + "";
    	let t0;
    	let t1_value = /*$translations*/ ctx[2].account + "";
    	let t1;
    	let t2;
    	let t3_value = /*account*/ ctx[0].id + "";
    	let t3;
    	let t4;
    	let h5;
    	let t5_value = /*account*/ ctx[0].type + "";
    	let t5;
    	let t6_value = /*$translations*/ ctx[2].account + "";
    	let t6;
    	let br0;
    	let t7;
    	let span0;
    	let t8_value = /*account*/ ctx[0].name + "";
    	let t8;
    	let t9;
    	let div0;
    	let strong;
    	let t10_value = formatMoney(/*account*/ ctx[0].amount) + "";
    	let t10;
    	let t11;
    	let br1;
    	let t12;
    	let span1;
    	let t13_value = /*$translations*/ ctx[2].balance + "";
    	let t13;
    	let t14;
    	let div1;
    	let mounted;
    	let dispose;

    	function select_block_type(ctx, dirty) {
    		if (!/*account*/ ctx[0].isFrozen) return create_if_block$6;
    		return create_else_block_1$2;
    	}

    	let current_block_type = select_block_type(ctx);
    	let if_block = current_block_type(ctx);

    	const block = {
    		c: function create() {
    			section = element("section");
    			h4 = element("h4");
    			t0 = text(t0_value);
    			t1 = text(t1_value);
    			t2 = text("/ ");
    			t3 = text(t3_value);
    			t4 = space();
    			h5 = element("h5");
    			t5 = text(t5_value);
    			t6 = text(t6_value);
    			br0 = element("br");
    			t7 = space();
    			span0 = element("span");
    			t8 = text(t8_value);
    			t9 = space();
    			div0 = element("div");
    			strong = element("strong");
    			t10 = text(t10_value);
    			t11 = space();
    			br1 = element("br");
    			t12 = space();
    			span1 = element("span");
    			t13 = text(t13_value);
    			t14 = space();
    			div1 = element("div");
    			if_block.c();
    			attr_dev(h4, "class", "svelte-1tbdaxv");
    			add_location(h4, file$c, 19, 4, 655);
    			add_location(br0, file$c, 23, 45, 784);
    			attr_dev(span0, "class", "svelte-1tbdaxv");
    			add_location(span0, file$c, 24, 8, 799);
    			attr_dev(h5, "class", "svelte-1tbdaxv");
    			add_location(h5, file$c, 22, 4, 734);
    			attr_dev(strong, "class", "svelte-1tbdaxv");
    			add_location(strong, file$c, 28, 8, 870);
    			add_location(br1, file$c, 28, 55, 917);
    			add_location(span1, file$c, 29, 8, 932);
    			attr_dev(div0, "class", "price svelte-1tbdaxv");
    			add_location(div0, file$c, 27, 4, 842);
    			attr_dev(div1, "class", "btns-group svelte-1tbdaxv");
    			add_location(div1, file$c, 32, 4, 985);
    			attr_dev(section, "class", "account svelte-1tbdaxv");
    			add_location(section, file$c, 18, 0, 579);
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, section, anchor);
    			append_dev(section, h4);
    			append_dev(h4, t0);
    			append_dev(h4, t1);
    			append_dev(h4, t2);
    			append_dev(h4, t3);
    			append_dev(section, t4);
    			append_dev(section, h5);
    			append_dev(h5, t5);
    			append_dev(h5, t6);
    			append_dev(h5, br0);
    			append_dev(h5, t7);
    			append_dev(h5, span0);
    			append_dev(span0, t8);
    			append_dev(section, t9);
    			append_dev(section, div0);
    			append_dev(div0, strong);
    			append_dev(strong, t10);
    			append_dev(div0, t11);
    			append_dev(div0, br1);
    			append_dev(div0, t12);
    			append_dev(div0, span1);
    			append_dev(span1, t13);
    			append_dev(section, t14);
    			append_dev(section, div1);
    			if_block.m(div1, null);

    			if (!mounted) {
    				dispose = listen_dev(section, "click", /*click_handler_4*/ ctx[9], false, false, false, false);
    				mounted = true;
    			}
    		},
    		p: function update(ctx, [dirty]) {
    			if (dirty & /*account*/ 1 && t0_value !== (t0_value = /*account*/ ctx[0].type + "")) set_data_dev(t0, t0_value);
    			if (dirty & /*$translations*/ 4 && t1_value !== (t1_value = /*$translations*/ ctx[2].account + "")) set_data_dev(t1, t1_value);
    			if (dirty & /*account*/ 1 && t3_value !== (t3_value = /*account*/ ctx[0].id + "")) set_data_dev(t3, t3_value);
    			if (dirty & /*account*/ 1 && t5_value !== (t5_value = /*account*/ ctx[0].type + "")) set_data_dev(t5, t5_value);
    			if (dirty & /*$translations*/ 4 && t6_value !== (t6_value = /*$translations*/ ctx[2].account + "")) set_data_dev(t6, t6_value);
    			if (dirty & /*account*/ 1 && t8_value !== (t8_value = /*account*/ ctx[0].name + "")) set_data_dev(t8, t8_value);
    			if (dirty & /*account*/ 1 && t10_value !== (t10_value = formatMoney(/*account*/ ctx[0].amount) + "")) set_data_dev(t10, t10_value);
    			if (dirty & /*$translations*/ 4 && t13_value !== (t13_value = /*$translations*/ ctx[2].balance + "")) set_data_dev(t13, t13_value);

    			if (current_block_type === (current_block_type = select_block_type(ctx)) && if_block) {
    				if_block.p(ctx, dirty);
    			} else {
    				if_block.d(1);
    				if_block = current_block_type(ctx);

    				if (if_block) {
    					if_block.c();
    					if_block.m(div1, null);
    				}
    			}
    		},
    		i: noop,
    		o: noop,
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(section);
    			if_block.d();
    			mounted = false;
    			dispose();
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment$c.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function instance$c($$self, $$props, $$invalidate) {
    	let $accounts;
    	let $translations;
    	validate_store(accounts, 'accounts');
    	component_subscribe($$self, accounts, $$value => $$invalidate(10, $accounts = $$value));
    	validate_store(translations, 'translations');
    	component_subscribe($$self, translations, $$value => $$invalidate(2, $translations = $$value));
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('AccountListItem', slots, []);
    	let { account } = $$props;

    	function handleAccountClick(id) {
    		activeAccount.update(() => id);
    	}
    	let isAtm;

    	function handleButton(id, type) {
    		let account = $accounts.find(accountItem => id === accountItem.id);
    		popupDetails.update(() => ({ actionType: type, account }));
    	}

    	atm.subscribe(usingAtm => {
    		$$invalidate(1, isAtm = usingAtm);
    	});

    	$$self.$$.on_mount.push(function () {
    		if (account === undefined && !('account' in $$props || $$self.$$.bound[$$self.$$.props['account']])) {
    			console.warn("<AccountListItem> was created without expected prop 'account'");
    		}
    	});

    	const writable_props = ['account'];

    	Object.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console.warn(`<AccountListItem> was created with unknown prop '${key}'`);
    	});

    	const click_handler = () => handleButton(account.id, "deposit");
    	const click_handler_1 = () => handleButton(account.id, "deposit");
    	const click_handler_2 = () => handleButton(account.id, "withdraw");
    	const click_handler_3 = () => handleButton(account.id, "transfer");
    	const click_handler_4 = () => handleAccountClick(account.id);

    	$$self.$$set = $$props => {
    		if ('account' in $$props) $$invalidate(0, account = $$props.account);
    	};

    	$$self.$capture_state = () => ({
    		accounts,
    		activeAccount,
    		popupDetails,
    		atm,
    		translations,
    		formatMoney,
    		account,
    		handleAccountClick,
    		isAtm,
    		handleButton,
    		$accounts,
    		$translations
    	});

    	$$self.$inject_state = $$props => {
    		if ('account' in $$props) $$invalidate(0, account = $$props.account);
    		if ('isAtm' in $$props) $$invalidate(1, isAtm = $$props.isAtm);
    	};

    	if ($$props && "$$inject" in $$props) {
    		$$self.$inject_state($$props.$$inject);
    	}

    	return [
    		account,
    		isAtm,
    		$translations,
    		handleAccountClick,
    		handleButton,
    		click_handler,
    		click_handler_1,
    		click_handler_2,
    		click_handler_3,
    		click_handler_4
    	];
    }

    class AccountListItem extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance$c, create_fragment$c, safe_not_equal, { account: 0 });

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "AccountListItem",
    			options,
    			id: create_fragment$c.name
    		});
    	}

    	get account() {
    		throw new Error("<AccountListItem>: Props cannot be read directly from the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
    	}

    	set account(value) {
    		throw new Error("<AccountListItem>: Props cannot be set directly on the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
    	}
    }

    /* src\components\Accounts\AccountsList.svelte generated by Svelte v3.59.2 */
    const file$b = "src\\components\\Accounts\\AccountsList.svelte";

    function get_each_context$3(ctx, list, i) {
    	const child_ctx = ctx.slice();
    	child_ctx[6] = list[i];
    	return child_ctx;
    }

    // (14:8) {:else}
    function create_else_block$3(ctx) {
    	let h3;
    	let t_value = /*$translations*/ ctx[1].account_not_found + "";
    	let t;

    	const block = {
    		c: function create() {
    			h3 = element("h3");
    			t = text(t_value);
    			set_style(h3, "text-align", "left");
    			set_style(h3, "color", "#F3F4F5");
    			set_style(h3, "margin-top", "1rem");
    			add_location(h3, file$b, 14, 12, 704);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, h3, anchor);
    			append_dev(h3, t);
    		},
    		p: function update(ctx, dirty) {
    			if (dirty & /*$translations*/ 2 && t_value !== (t_value = /*$translations*/ ctx[1].account_not_found + "")) set_data_dev(t, t_value);
    		},
    		i: noop,
    		o: noop,
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(h3);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_else_block$3.name,
    		type: "else",
    		source: "(14:8) {:else}",
    		ctx
    	});

    	return block;
    }

    // (10:8) {#if $accounts.filter(item => item.name.toLowerCase().includes(accSearch.toLowerCase())).length > 0}
    function create_if_block$5(ctx) {
    	let each_blocks = [];
    	let each_1_lookup = new Map();
    	let each_1_anchor;
    	let current;
    	let each_value = /*$accounts*/ ctx[2].filter(/*func_1*/ ctx[5]);
    	validate_each_argument(each_value);
    	const get_key = ctx => /*account*/ ctx[6].id;
    	validate_each_keys(ctx, each_value, get_each_context$3, get_key);

    	for (let i = 0; i < each_value.length; i += 1) {
    		let child_ctx = get_each_context$3(ctx, each_value, i);
    		let key = get_key(child_ctx);
    		each_1_lookup.set(key, each_blocks[i] = create_each_block$3(key, child_ctx));
    	}

    	const block = {
    		c: function create() {
    			for (let i = 0; i < each_blocks.length; i += 1) {
    				each_blocks[i].c();
    			}

    			each_1_anchor = empty();
    		},
    		m: function mount(target, anchor) {
    			for (let i = 0; i < each_blocks.length; i += 1) {
    				if (each_blocks[i]) {
    					each_blocks[i].m(target, anchor);
    				}
    			}

    			insert_dev(target, each_1_anchor, anchor);
    			current = true;
    		},
    		p: function update(ctx, dirty) {
    			if (dirty & /*$accounts, accSearch*/ 5) {
    				each_value = /*$accounts*/ ctx[2].filter(/*func_1*/ ctx[5]);
    				validate_each_argument(each_value);
    				group_outros();
    				validate_each_keys(ctx, each_value, get_each_context$3, get_key);
    				each_blocks = update_keyed_each(each_blocks, dirty, get_key, 1, ctx, each_value, each_1_lookup, each_1_anchor.parentNode, outro_and_destroy_block, create_each_block$3, each_1_anchor, get_each_context$3);
    				check_outros();
    			}
    		},
    		i: function intro(local) {
    			if (current) return;

    			for (let i = 0; i < each_value.length; i += 1) {
    				transition_in(each_blocks[i]);
    			}

    			current = true;
    		},
    		o: function outro(local) {
    			for (let i = 0; i < each_blocks.length; i += 1) {
    				transition_out(each_blocks[i]);
    			}

    			current = false;
    		},
    		d: function destroy(detaching) {
    			for (let i = 0; i < each_blocks.length; i += 1) {
    				each_blocks[i].d(detaching);
    			}

    			if (detaching) detach_dev(each_1_anchor);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block$5.name,
    		type: "if",
    		source: "(10:8) {#if $accounts.filter(item => item.name.toLowerCase().includes(accSearch.toLowerCase())).length > 0}",
    		ctx
    	});

    	return block;
    }

    // (11:12) {#each $accounts.filter(item => item.name.toLowerCase().includes(accSearch.toLowerCase())) as account (account.id)}
    function create_each_block$3(key_1, ctx) {
    	let first;
    	let accountlistitem;
    	let current;

    	accountlistitem = new AccountListItem({
    			props: { account: /*account*/ ctx[6] },
    			$$inline: true
    		});

    	const block = {
    		key: key_1,
    		first: null,
    		c: function create() {
    			first = empty();
    			create_component(accountlistitem.$$.fragment);
    			this.first = first;
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, first, anchor);
    			mount_component(accountlistitem, target, anchor);
    			current = true;
    		},
    		p: function update(new_ctx, dirty) {
    			ctx = new_ctx;
    			const accountlistitem_changes = {};
    			if (dirty & /*$accounts, accSearch*/ 5) accountlistitem_changes.account = /*account*/ ctx[6];
    			accountlistitem.$set(accountlistitem_changes);
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(accountlistitem.$$.fragment, local);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(accountlistitem.$$.fragment, local);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(first);
    			destroy_component(accountlistitem, detaching);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_each_block$3.name,
    		type: "each",
    		source: "(11:12) {#each $accounts.filter(item => item.name.toLowerCase().includes(accSearch.toLowerCase())) as account (account.id)}",
    		ctx
    	});

    	return block;
    }

    function create_fragment$b(ctx) {
    	let aside;
    	let h3;
    	let t0_value = /*$translations*/ ctx[1].accounts + "";
    	let t0;
    	let t1;
    	let input;
    	let input_placeholder_value;
    	let t2;
    	let section;
    	let show_if;
    	let current_block_type_index;
    	let if_block;
    	let current;
    	let mounted;
    	let dispose;
    	const if_block_creators = [create_if_block$5, create_else_block$3];
    	const if_blocks = [];

    	function select_block_type(ctx, dirty) {
    		if (dirty & /*$accounts, accSearch*/ 5) show_if = null;
    		if (show_if == null) show_if = !!(/*$accounts*/ ctx[2].filter(/*func*/ ctx[3]).length > 0);
    		if (show_if) return 0;
    		return 1;
    	}

    	current_block_type_index = select_block_type(ctx, -1);
    	if_block = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx);

    	const block = {
    		c: function create() {
    			aside = element("aside");
    			h3 = element("h3");
    			t0 = text(t0_value);
    			t1 = space();
    			input = element("input");
    			t2 = space();
    			section = element("section");
    			if_block.c();
    			attr_dev(h3, "class", "heading");
    			add_location(h3, file$b, 6, 4, 181);
    			attr_dev(input, "type", "text");
    			attr_dev(input, "class", "acc-search svelte-tkkr7b");
    			attr_dev(input, "placeholder", input_placeholder_value = /*$translations*/ ctx[1].account_search);
    			add_location(input, file$b, 7, 4, 235);
    			attr_dev(section, "class", "scroller");
    			add_location(section, file$b, 8, 4, 346);
    			attr_dev(aside, "class", "svelte-tkkr7b");
    			add_location(aside, file$b, 5, 0, 169);
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, aside, anchor);
    			append_dev(aside, h3);
    			append_dev(h3, t0);
    			append_dev(aside, t1);
    			append_dev(aside, input);
    			set_input_value(input, /*accSearch*/ ctx[0]);
    			append_dev(aside, t2);
    			append_dev(aside, section);
    			if_blocks[current_block_type_index].m(section, null);
    			current = true;

    			if (!mounted) {
    				dispose = listen_dev(input, "input", /*input_input_handler*/ ctx[4]);
    				mounted = true;
    			}
    		},
    		p: function update(ctx, [dirty]) {
    			if ((!current || dirty & /*$translations*/ 2) && t0_value !== (t0_value = /*$translations*/ ctx[1].accounts + "")) set_data_dev(t0, t0_value);

    			if (!current || dirty & /*$translations*/ 2 && input_placeholder_value !== (input_placeholder_value = /*$translations*/ ctx[1].account_search)) {
    				attr_dev(input, "placeholder", input_placeholder_value);
    			}

    			if (dirty & /*accSearch*/ 1 && input.value !== /*accSearch*/ ctx[0]) {
    				set_input_value(input, /*accSearch*/ ctx[0]);
    			}

    			let previous_block_index = current_block_type_index;
    			current_block_type_index = select_block_type(ctx, dirty);

    			if (current_block_type_index === previous_block_index) {
    				if_blocks[current_block_type_index].p(ctx, dirty);
    			} else {
    				group_outros();

    				transition_out(if_blocks[previous_block_index], 1, 1, () => {
    					if_blocks[previous_block_index] = null;
    				});

    				check_outros();
    				if_block = if_blocks[current_block_type_index];

    				if (!if_block) {
    					if_block = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx);
    					if_block.c();
    				} else {
    					if_block.p(ctx, dirty);
    				}

    				transition_in(if_block, 1);
    				if_block.m(section, null);
    			}
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(if_block);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(if_block);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(aside);
    			if_blocks[current_block_type_index].d();
    			mounted = false;
    			dispose();
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment$b.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function instance$b($$self, $$props, $$invalidate) {
    	let $translations;
    	let $accounts;
    	validate_store(translations, 'translations');
    	component_subscribe($$self, translations, $$value => $$invalidate(1, $translations = $$value));
    	validate_store(accounts, 'accounts');
    	component_subscribe($$self, accounts, $$value => $$invalidate(2, $accounts = $$value));
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('AccountsList', slots, []);
    	let accSearch = "";
    	const writable_props = [];

    	Object.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console.warn(`<AccountsList> was created with unknown prop '${key}'`);
    	});

    	const func = item => item.name.toLowerCase().includes(accSearch.toLowerCase());

    	function input_input_handler() {
    		accSearch = this.value;
    		$$invalidate(0, accSearch);
    	}

    	const func_1 = item => item.name.toLowerCase().includes(accSearch.toLowerCase());

    	$$self.$capture_state = () => ({
    		accounts,
    		translations,
    		AccountListItem,
    		accSearch,
    		$translations,
    		$accounts
    	});

    	$$self.$inject_state = $$props => {
    		if ('accSearch' in $$props) $$invalidate(0, accSearch = $$props.accSearch);
    	};

    	if ($$props && "$$inject" in $$props) {
    		$$self.$inject_state($$props.$$inject);
    	}

    	return [accSearch, $translations, $accounts, func, input_input_handler, func_1];
    }

    class AccountsList extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance$b, create_fragment$b, safe_not_equal, {});

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "AccountsList",
    			options,
    			id: create_fragment$b.name
    		});
    	}
    }

    /* src\components\Accounts\AccountTransactionItem.svelte generated by Svelte v3.59.2 */
    const file$a = "src\\components\\Accounts\\AccountTransactionItem.svelte";

    function create_fragment$a(ctx) {
    	let section;
    	let h5;
    	let span0;
    	let t0_value = /*transaction*/ ctx[0].title + "";
    	let t0;
    	let t1;
    	let p;
    	let t2;
    	let t3_value = /*transaction*/ ctx[0].trans_type.toUpperCase() + "";
    	let t3;
    	let t4;
    	let t5;
    	let span1;
    	let t6_value = /*transaction*/ ctx[0].trans_id + "";
    	let t6;
    	let t7;
    	let h4;
    	let div;
    	let span2;
    	let i;
    	let t8;
    	let t9_value = formatMoney(/*transaction*/ ctx[0].amount) + "";
    	let t9;
    	let t10;
    	let span3;
    	let t11_value = /*transaction*/ ctx[0].receiver + "";
    	let t11;
    	let t12;
    	let span4;
    	let t13_value = /*getTimeElapsed*/ ctx[2](/*transaction*/ ctx[0].time) + "";
    	let t13;
    	let t14;
    	let br0;
    	let t15;
    	let t16_value = /*transaction*/ ctx[0].issuer + "";
    	let t16;
    	let t17;
    	let h6;
    	let t18_value = /*$translations*/ ctx[1].message + "";
    	let t18;
    	let t19;
    	let br1;
    	let t20;
    	let t21_value = /*transaction*/ ctx[0].message + "";
    	let t21;

    	const block = {
    		c: function create() {
    			section = element("section");
    			h5 = element("h5");
    			span0 = element("span");
    			t0 = text(t0_value);
    			t1 = space();
    			p = element("p");
    			t2 = text("[");
    			t3 = text(t3_value);
    			t4 = text("]");
    			t5 = space();
    			span1 = element("span");
    			t6 = text(t6_value);
    			t7 = space();
    			h4 = element("h4");
    			div = element("div");
    			span2 = element("span");
    			i = element("i");
    			t8 = space();
    			t9 = text(t9_value);
    			t10 = space();
    			span3 = element("span");
    			t11 = text(t11_value);
    			t12 = space();
    			span4 = element("span");
    			t13 = text(t13_value);
    			t14 = space();
    			br0 = element("br");
    			t15 = space();
    			t16 = text(t16_value);
    			t17 = space();
    			h6 = element("h6");
    			t18 = text(t18_value);
    			t19 = space();
    			br1 = element("br");
    			t20 = space();
    			t21 = text(t21_value);
    			attr_dev(p, "class", "svelte-ysgu19");
    			add_location(p, file$a, 45, 12, 1514);
    			attr_dev(span0, "class", "title-container svelte-ysgu19");
    			toggle_class(span0, "withdrawTitle", /*transaction*/ ctx[0].trans_type === "withdraw");
    			add_location(span0, file$a, 43, 8, 1379);
    			attr_dev(span1, "class", "trans_id svelte-ysgu19");
    			toggle_class(span1, "withdrawId", /*transaction*/ ctx[0].trans_type === "withdraw");
    			add_location(span1, file$a, 47, 8, 1586);
    			attr_dev(h5, "class", "svelte-ysgu19");
    			add_location(h5, file$a, 42, 4, 1366);
    			attr_dev(i, "class", "fa-solid fa-money-bill");
    			add_location(i, file$a, 52, 16, 1920);
    			attr_dev(span2, "class", "svelte-ysgu19");
    			toggle_class(span2, "withdraw", /*transaction*/ ctx[0].trans_type === "withdraw");
    			add_location(span2, file$a, 51, 12, 1842);
    			set_style(div, "display", "flex");
    			set_style(div, "flex-direction", "column");
    			set_style(div, "justify-content", "flex-start");
    			set_style(div, "align-items", "flex-start");
    			add_location(div, file$a, 50, 8, 1723);
    			attr_dev(span3, "class", "svelte-ysgu19");
    			add_location(span3, file$a, 56, 8, 2052);
    			add_location(br0, file$a, 57, 49, 2139);
    			attr_dev(span4, "class", "svelte-ysgu19");
    			add_location(span4, file$a, 57, 8, 2098);
    			attr_dev(h4, "class", "svelte-ysgu19");
    			add_location(h4, file$a, 49, 4, 1710);
    			add_location(br1, file$a, 61, 32, 2226);
    			attr_dev(h6, "class", "svelte-ysgu19");
    			add_location(h6, file$a, 60, 4, 2189);
    			attr_dev(section, "class", "transaction svelte-ysgu19");
    			add_location(section, file$a, 41, 0, 1332);
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, section, anchor);
    			append_dev(section, h5);
    			append_dev(h5, span0);
    			append_dev(span0, t0);
    			append_dev(span0, t1);
    			append_dev(span0, p);
    			append_dev(p, t2);
    			append_dev(p, t3);
    			append_dev(p, t4);
    			append_dev(h5, t5);
    			append_dev(h5, span1);
    			append_dev(span1, t6);
    			append_dev(section, t7);
    			append_dev(section, h4);
    			append_dev(h4, div);
    			append_dev(div, span2);
    			append_dev(span2, i);
    			append_dev(span2, t8);
    			append_dev(span2, t9);
    			append_dev(h4, t10);
    			append_dev(h4, span3);
    			append_dev(span3, t11);
    			append_dev(h4, t12);
    			append_dev(h4, span4);
    			append_dev(span4, t13);
    			append_dev(span4, t14);
    			append_dev(span4, br0);
    			append_dev(span4, t15);
    			append_dev(span4, t16);
    			append_dev(section, t17);
    			append_dev(section, h6);
    			append_dev(h6, t18);
    			append_dev(h6, t19);
    			append_dev(h6, br1);
    			append_dev(h6, t20);
    			append_dev(h6, t21);
    		},
    		p: function update(ctx, [dirty]) {
    			if (dirty & /*transaction*/ 1 && t0_value !== (t0_value = /*transaction*/ ctx[0].title + "")) set_data_dev(t0, t0_value);
    			if (dirty & /*transaction*/ 1 && t3_value !== (t3_value = /*transaction*/ ctx[0].trans_type.toUpperCase() + "")) set_data_dev(t3, t3_value);

    			if (dirty & /*transaction*/ 1) {
    				toggle_class(span0, "withdrawTitle", /*transaction*/ ctx[0].trans_type === "withdraw");
    			}

    			if (dirty & /*transaction*/ 1 && t6_value !== (t6_value = /*transaction*/ ctx[0].trans_id + "")) set_data_dev(t6, t6_value);

    			if (dirty & /*transaction*/ 1) {
    				toggle_class(span1, "withdrawId", /*transaction*/ ctx[0].trans_type === "withdraw");
    			}

    			if (dirty & /*transaction*/ 1 && t9_value !== (t9_value = formatMoney(/*transaction*/ ctx[0].amount) + "")) set_data_dev(t9, t9_value);

    			if (dirty & /*transaction*/ 1) {
    				toggle_class(span2, "withdraw", /*transaction*/ ctx[0].trans_type === "withdraw");
    			}

    			if (dirty & /*transaction*/ 1 && t11_value !== (t11_value = /*transaction*/ ctx[0].receiver + "")) set_data_dev(t11, t11_value);
    			if (dirty & /*transaction*/ 1 && t13_value !== (t13_value = /*getTimeElapsed*/ ctx[2](/*transaction*/ ctx[0].time) + "")) set_data_dev(t13, t13_value);
    			if (dirty & /*transaction*/ 1 && t16_value !== (t16_value = /*transaction*/ ctx[0].issuer + "")) set_data_dev(t16, t16_value);
    			if (dirty & /*$translations*/ 2 && t18_value !== (t18_value = /*$translations*/ ctx[1].message + "")) set_data_dev(t18, t18_value);
    			if (dirty & /*transaction*/ 1 && t21_value !== (t21_value = /*transaction*/ ctx[0].message + "")) set_data_dev(t21, t21_value);
    		},
    		i: noop,
    		o: noop,
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(section);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment$a.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function instance$a($$self, $$props, $$invalidate) {
    	let $translations;
    	validate_store(translations, 'translations');
    	component_subscribe($$self, translations, $$value => $$invalidate(1, $translations = $$value));
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('AccountTransactionItem', slots, []);
    	let { transaction } = $$props;

    	function getTimeElapsed(seconds) {
    		let retData;
    		const timestamp = Math.floor(Date.now() / 1000) - seconds;
    		const minutes = Math.floor(timestamp / 60);
    		const hours = Math.floor(minutes / 60);
    		const days = Math.floor(hours / 24);
    		const weeks = Math.floor(days / 7);

    		if (weeks !== 0 && weeks > 1) {
    			retData = $translations.weeks.replace("%s", weeks);
    		} else if (weeks !== 0 && weeks === 1) {
    			retData = $translations.aweek;
    		} else if (days !== 0 && days > 1) {
    			retData = $translations.days.replace("%s", days);
    		} else if (days !== 0 && days === 1) {
    			retData = $translations.aday;
    		} else if (hours !== 0 && hours > 1) {
    			retData = $translations.hours.replace("%s", hours);
    		} else if (hours !== 0 && hours === 1) {
    			retData = $translations.ahour;
    		} else if (minutes !== 0 && minutes > 1) {
    			retData = $translations.mins.replace("%s", minutes);
    		} else if (minutes !== 0 && minutes === 1) {
    			retData = $translations.amin;
    		} else {
    			retData = $translations.secs;
    		}

    		return retData;
    	}

    	$$self.$$.on_mount.push(function () {
    		if (transaction === undefined && !('transaction' in $$props || $$self.$$.bound[$$self.$$.props['transaction']])) {
    			console.warn("<AccountTransactionItem> was created without expected prop 'transaction'");
    		}
    	});

    	const writable_props = ['transaction'];

    	Object.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console.warn(`<AccountTransactionItem> was created with unknown prop '${key}'`);
    	});

    	$$self.$$set = $$props => {
    		if ('transaction' in $$props) $$invalidate(0, transaction = $$props.transaction);
    	};

    	$$self.$capture_state = () => ({
    		transaction,
    		formatMoney,
    		translations,
    		getTimeElapsed,
    		$translations
    	});

    	$$self.$inject_state = $$props => {
    		if ('transaction' in $$props) $$invalidate(0, transaction = $$props.transaction);
    	};

    	if ($$props && "$$inject" in $$props) {
    		$$self.$inject_state($$props.$$inject);
    	}

    	return [transaction, $translations, getTimeElapsed];
    }

    class AccountTransactionItem extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance$a, create_fragment$a, safe_not_equal, { transaction: 0 });

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "AccountTransactionItem",
    			options,
    			id: create_fragment$a.name
    		});
    	}

    	get transaction() {
    		throw new Error("<AccountTransactionItem>: Props cannot be read directly from the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
    	}

    	set transaction(value) {
    		throw new Error("<AccountTransactionItem>: Props cannot be set directly on the component instance unless compiling with 'accessors: true' or '<svelte:options accessors/>'");
    	}
    }

    // yoinked from https://github.com/overextended/ox_lib/blob/master/web/src/utils/setClipboard.ts
    const setClipboard = (value) => {
        const clipElem = document.createElement('input');
        clipElem.value = value;
        document.body.appendChild(clipElem);
        clipElem.select();
        document.execCommand('copy');
        document.body.removeChild(clipElem);
    };

    /* src\components\Accounts\AccountTransactionsList.svelte generated by Svelte v3.59.2 */

    const { console: console_1$1 } = globals;
    const file$9 = "src\\components\\Accounts\\AccountTransactionsList.svelte";

    function get_each_context$2(ctx, list, i) {
    	const child_ctx = ctx.slice();
    	child_ctx[12] = list[i];
    	return child_ctx;
    }

    // (70:8) {:else}
    function create_else_block_2(ctx) {
    	let t_value = /*$translations*/ ctx[3].select_account + "";
    	let t;

    	const block = {
    		c: function create() {
    			t = text(t_value);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, t, anchor);
    		},
    		p: function update(ctx, dirty) {
    			if (dirty & /*$translations*/ 8 && t_value !== (t_value = /*$translations*/ ctx[3].select_account + "")) set_data_dev(t, t_value);
    		},
    		i: noop,
    		o: noop,
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(t);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_else_block_2.name,
    		type: "else",
    		source: "(70:8) {:else}",
    		ctx
    	});

    	return block;
    }

    // (62:8) {#if account}
    function create_if_block_1$2(ctx) {
    	let show_if;
    	let current_block_type_index;
    	let if_block;
    	let if_block_anchor;
    	let current;
    	const if_block_creators = [create_if_block_2$1, create_else_block_1$1];
    	const if_blocks = [];

    	function select_block_type_1(ctx, dirty) {
    		if (dirty & /*account, transSearch*/ 5) show_if = null;
    		if (show_if == null) show_if = !!(/*account*/ ctx[2].transactions.filter(/*func*/ ctx[7]).length > 0);
    		if (show_if) return 0;
    		return 1;
    	}

    	current_block_type_index = select_block_type_1(ctx, -1);
    	if_block = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx);

    	const block = {
    		c: function create() {
    			if_block.c();
    			if_block_anchor = empty();
    		},
    		m: function mount(target, anchor) {
    			if_blocks[current_block_type_index].m(target, anchor);
    			insert_dev(target, if_block_anchor, anchor);
    			current = true;
    		},
    		p: function update(ctx, dirty) {
    			let previous_block_index = current_block_type_index;
    			current_block_type_index = select_block_type_1(ctx, dirty);

    			if (current_block_type_index === previous_block_index) {
    				if_blocks[current_block_type_index].p(ctx, dirty);
    			} else {
    				group_outros();

    				transition_out(if_blocks[previous_block_index], 1, 1, () => {
    					if_blocks[previous_block_index] = null;
    				});

    				check_outros();
    				if_block = if_blocks[current_block_type_index];

    				if (!if_block) {
    					if_block = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx);
    					if_block.c();
    				} else {
    					if_block.p(ctx, dirty);
    				}

    				transition_in(if_block, 1);
    				if_block.m(if_block_anchor.parentNode, if_block_anchor);
    			}
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(if_block);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(if_block);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			if_blocks[current_block_type_index].d(detaching);
    			if (detaching) detach_dev(if_block_anchor);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block_1$2.name,
    		type: "if",
    		source: "(62:8) {#if account}",
    		ctx
    	});

    	return block;
    }

    // (67:12) {:else}
    function create_else_block_1$1(ctx) {
    	let h3;
    	let t_value = /*$translations*/ ctx[3].trans_not_found + "";
    	let t;

    	const block = {
    		c: function create() {
    			h3 = element("h3");
    			t = text(t_value);
    			set_style(h3, "text-align", "left");
    			set_style(h3, "color", "#F3F4F5");
    			set_style(h3, "margin-top", "1rem");
    			add_location(h3, file$9, 67, 16, 2713);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, h3, anchor);
    			append_dev(h3, t);
    		},
    		p: function update(ctx, dirty) {
    			if (dirty & /*$translations*/ 8 && t_value !== (t_value = /*$translations*/ ctx[3].trans_not_found + "")) set_data_dev(t, t_value);
    		},
    		i: noop,
    		o: noop,
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(h3);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_else_block_1$1.name,
    		type: "else",
    		source: "(67:12) {:else}",
    		ctx
    	});

    	return block;
    }

    // (63:12) {#if account.transactions.filter(item => item.message.toLowerCase().includes(transSearch.toLowerCase()) || item.trans_id.toLowerCase().includes(transSearch.toLowerCase()) || item.receiver.toLowerCase().includes(transSearch.toLowerCase())).length > 0}
    function create_if_block_2$1(ctx) {
    	let each_blocks = [];
    	let each_1_lookup = new Map();
    	let each_1_anchor;
    	let current;
    	let each_value = /*account*/ ctx[2].transactions.filter(/*func_1*/ ctx[9]);
    	validate_each_argument(each_value);
    	const get_key = ctx => /*transaction*/ ctx[12].trans_id;
    	validate_each_keys(ctx, each_value, get_each_context$2, get_key);

    	for (let i = 0; i < each_value.length; i += 1) {
    		let child_ctx = get_each_context$2(ctx, each_value, i);
    		let key = get_key(child_ctx);
    		each_1_lookup.set(key, each_blocks[i] = create_each_block$2(key, child_ctx));
    	}

    	const block = {
    		c: function create() {
    			for (let i = 0; i < each_blocks.length; i += 1) {
    				each_blocks[i].c();
    			}

    			each_1_anchor = empty();
    		},
    		m: function mount(target, anchor) {
    			for (let i = 0; i < each_blocks.length; i += 1) {
    				if (each_blocks[i]) {
    					each_blocks[i].m(target, anchor);
    				}
    			}

    			insert_dev(target, each_1_anchor, anchor);
    			current = true;
    		},
    		p: function update(ctx, dirty) {
    			if (dirty & /*account, transSearch*/ 5) {
    				each_value = /*account*/ ctx[2].transactions.filter(/*func_1*/ ctx[9]);
    				validate_each_argument(each_value);
    				group_outros();
    				validate_each_keys(ctx, each_value, get_each_context$2, get_key);
    				each_blocks = update_keyed_each(each_blocks, dirty, get_key, 1, ctx, each_value, each_1_lookup, each_1_anchor.parentNode, outro_and_destroy_block, create_each_block$2, each_1_anchor, get_each_context$2);
    				check_outros();
    			}
    		},
    		i: function intro(local) {
    			if (current) return;

    			for (let i = 0; i < each_value.length; i += 1) {
    				transition_in(each_blocks[i]);
    			}

    			current = true;
    		},
    		o: function outro(local) {
    			for (let i = 0; i < each_blocks.length; i += 1) {
    				transition_out(each_blocks[i]);
    			}

    			current = false;
    		},
    		d: function destroy(detaching) {
    			for (let i = 0; i < each_blocks.length; i += 1) {
    				each_blocks[i].d(detaching);
    			}

    			if (detaching) detach_dev(each_1_anchor);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block_2$1.name,
    		type: "if",
    		source: "(63:12) {#if account.transactions.filter(item => item.message.toLowerCase().includes(transSearch.toLowerCase()) || item.trans_id.toLowerCase().includes(transSearch.toLowerCase()) || item.receiver.toLowerCase().includes(transSearch.toLowerCase())).length > 0}",
    		ctx
    	});

    	return block;
    }

    // (64:16) {#each account.transactions.filter(item => item.message.toLowerCase().includes(transSearch.toLowerCase()) || item.trans_id.toLowerCase().includes(transSearch.toLowerCase()) || item.receiver.toLowerCase().includes(transSearch.toLowerCase())) as transaction (transaction.trans_id)}
    function create_each_block$2(key_1, ctx) {
    	let first;
    	let accounttransactionitem;
    	let current;

    	accounttransactionitem = new AccountTransactionItem({
    			props: { transaction: /*transaction*/ ctx[12] },
    			$$inline: true
    		});

    	const block = {
    		key: key_1,
    		first: null,
    		c: function create() {
    			first = empty();
    			create_component(accounttransactionitem.$$.fragment);
    			this.first = first;
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, first, anchor);
    			mount_component(accounttransactionitem, target, anchor);
    			current = true;
    		},
    		p: function update(new_ctx, dirty) {
    			ctx = new_ctx;
    			const accounttransactionitem_changes = {};
    			if (dirty & /*account, transSearch*/ 5) accounttransactionitem_changes.transaction = /*transaction*/ ctx[12];
    			accounttransactionitem.$set(accounttransactionitem_changes);
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(accounttransactionitem.$$.fragment, local);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(accounttransactionitem.$$.fragment, local);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(first);
    			destroy_component(accounttransactionitem, detaching);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_each_block$2.name,
    		type: "each",
    		source: "(64:16) {#each account.transactions.filter(item => item.message.toLowerCase().includes(transSearch.toLowerCase()) || item.trans_id.toLowerCase().includes(transSearch.toLowerCase()) || item.receiver.toLowerCase().includes(transSearch.toLowerCase())) as transaction (transaction.trans_id)}",
    		ctx
    	});

    	return block;
    }

    // (86:4) {:else}
    function create_else_block$2(ctx) {
    	let div;
    	let button;
    	let i;
    	let t0;
    	let t1_value = /*$translations*/ ctx[3].export_data + "";
    	let t1;
    	let mounted;
    	let dispose;

    	const block = {
    		c: function create() {
    			div = element("div");
    			button = element("button");
    			i = element("i");
    			t0 = space();
    			t1 = text(t1_value);
    			attr_dev(i, "class", "fa-solid fa-file-export fa-fw");
    			add_location(i, file$9, 93, 169, 4644);
    			attr_dev(button, "class", "btn btn-green");
    			set_style(button, "display", "flex");
    			set_style(button, "align-items", "center");
    			set_style(button, "justify-content", "center");
    			set_style(button, "gap", "1rem");
    			add_location(button, file$9, 93, 12, 4487);
    			attr_dev(div, "class", "export-data svelte-fkqv90");
    			add_location(div, file$9, 86, 8, 3867);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, div, anchor);
    			append_dev(div, button);
    			append_dev(button, i);
    			append_dev(button, t0);
    			append_dev(button, t1);

    			if (!mounted) {
    				dispose = listen_dev(button, "click", prevent_default(/*handleClickExportData*/ ctx[4]), false, true, false, false);
    				mounted = true;
    			}
    		},
    		p: function update(ctx, dirty) {
    			if (dirty & /*$translations*/ 8 && t1_value !== (t1_value = /*$translations*/ ctx[3].export_data + "")) set_data_dev(t1, t1_value);
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(div);
    			mounted = false;
    			dispose();
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_else_block$2.name,
    		type: "else",
    		source: "(86:4) {:else}",
    		ctx
    	});

    	return block;
    }

    // (74:4) {#if !isAtm}
    function create_if_block$4(ctx) {
    	let div;
    	let button;
    	let i;
    	let t0;
    	let t1_value = /*$translations*/ ctx[3].export_data + "";
    	let t1;
    	let mounted;
    	let dispose;

    	const block = {
    		c: function create() {
    			div = element("div");
    			button = element("button");
    			i = element("i");
    			t0 = space();
    			t1 = text(t1_value);
    			attr_dev(i, "class", "fa-solid fa-file-export fa-fw");
    			add_location(i, file$9, 81, 169, 3722);
    			attr_dev(button, "class", "btn btn-green");
    			set_style(button, "display", "flex");
    			set_style(button, "align-items", "center");
    			set_style(button, "justify-content", "center");
    			set_style(button, "gap", "1rem");
    			add_location(button, file$9, 81, 12, 3565);
    			attr_dev(div, "class", "export-data svelte-fkqv90");
    			add_location(div, file$9, 74, 8, 2945);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, div, anchor);
    			append_dev(div, button);
    			append_dev(button, i);
    			append_dev(button, t0);
    			append_dev(button, t1);

    			if (!mounted) {
    				dispose = listen_dev(button, "click", prevent_default(/*handleClickExportData*/ ctx[4]), false, true, false, false);
    				mounted = true;
    			}
    		},
    		p: function update(ctx, dirty) {
    			if (dirty & /*$translations*/ 8 && t1_value !== (t1_value = /*$translations*/ ctx[3].export_data + "")) set_data_dev(t1, t1_value);
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(div);
    			mounted = false;
    			dispose();
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block$4.name,
    		type: "if",
    		source: "(74:4) {#if !isAtm}",
    		ctx
    	});

    	return block;
    }

    function create_fragment$9(ctx) {
    	let section1;
    	let h3;
    	let span0;
    	let t0_value = /*$translations*/ ctx[3].transactions + "";
    	let t0;
    	let t1;
    	let div;
    	let img;
    	let img_src_value;
    	let t2;
    	let span1;
    	let t3_value = /*$translations*/ ctx[3].bank_name + "";
    	let t3;
    	let t4;
    	let input;
    	let input_placeholder_value;
    	let t5;
    	let section0;
    	let current_block_type_index;
    	let if_block0;
    	let t6;
    	let current;
    	let mounted;
    	let dispose;
    	const if_block_creators = [create_if_block_1$2, create_else_block_2];
    	const if_blocks = [];

    	function select_block_type(ctx, dirty) {
    		if (/*account*/ ctx[2]) return 0;
    		return 1;
    	}

    	current_block_type_index = select_block_type(ctx);
    	if_block0 = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx);

    	function select_block_type_2(ctx, dirty) {
    		if (!/*isAtm*/ ctx[1]) return create_if_block$4;
    		return create_else_block$2;
    	}

    	let current_block_type = select_block_type_2(ctx);
    	let if_block1 = current_block_type(ctx);

    	const block = {
    		c: function create() {
    			section1 = element("section");
    			h3 = element("h3");
    			span0 = element("span");
    			t0 = text(t0_value);
    			t1 = space();
    			div = element("div");
    			img = element("img");
    			t2 = space();
    			span1 = element("span");
    			t3 = text(t3_value);
    			t4 = space();
    			input = element("input");
    			t5 = space();
    			section0 = element("section");
    			if_block0.c();
    			t6 = space();
    			if_block1.c();
    			add_location(span0, file$9, 51, 8, 1672);
    			if (!src_url_equal(img.src, img_src_value = "./img/bank.png")) attr_dev(img, "src", img_src_value);
    			attr_dev(img, "alt", "bang icon");
    			attr_dev(img, "class", "svelte-fkqv90");
    			add_location(img, file$9, 54, 12, 1741);
    			add_location(span1, file$9, 55, 12, 1798);
    			attr_dev(div, "class", "svelte-fkqv90");
    			add_location(div, file$9, 53, 8, 1723);
    			attr_dev(h3, "class", "heading svelte-fkqv90");
    			add_location(h3, file$9, 50, 4, 1643);
    			attr_dev(input, "type", "text");
    			attr_dev(input, "class", "transactions-search svelte-fkqv90");
    			attr_dev(input, "placeholder", input_placeholder_value = /*$translations*/ ctx[3].trans_search);
    			add_location(input, file$9, 59, 4, 1867);
    			attr_dev(section0, "class", "scroller svelte-fkqv90");
    			add_location(section0, file$9, 60, 4, 1985);
    			attr_dev(section1, "class", "transactions-container svelte-fkqv90");
    			add_location(section1, file$9, 49, 0, 1598);
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, section1, anchor);
    			append_dev(section1, h3);
    			append_dev(h3, span0);
    			append_dev(span0, t0);
    			append_dev(h3, t1);
    			append_dev(h3, div);
    			append_dev(div, img);
    			append_dev(div, t2);
    			append_dev(div, span1);
    			append_dev(span1, t3);
    			append_dev(section1, t4);
    			append_dev(section1, input);
    			set_input_value(input, /*transSearch*/ ctx[0]);
    			append_dev(section1, t5);
    			append_dev(section1, section0);
    			if_blocks[current_block_type_index].m(section0, null);
    			append_dev(section1, t6);
    			if_block1.m(section1, null);
    			current = true;

    			if (!mounted) {
    				dispose = listen_dev(input, "input", /*input_input_handler*/ ctx[8]);
    				mounted = true;
    			}
    		},
    		p: function update(ctx, [dirty]) {
    			if ((!current || dirty & /*$translations*/ 8) && t0_value !== (t0_value = /*$translations*/ ctx[3].transactions + "")) set_data_dev(t0, t0_value);
    			if ((!current || dirty & /*$translations*/ 8) && t3_value !== (t3_value = /*$translations*/ ctx[3].bank_name + "")) set_data_dev(t3, t3_value);

    			if (!current || dirty & /*$translations*/ 8 && input_placeholder_value !== (input_placeholder_value = /*$translations*/ ctx[3].trans_search)) {
    				attr_dev(input, "placeholder", input_placeholder_value);
    			}

    			if (dirty & /*transSearch*/ 1 && input.value !== /*transSearch*/ ctx[0]) {
    				set_input_value(input, /*transSearch*/ ctx[0]);
    			}

    			let previous_block_index = current_block_type_index;
    			current_block_type_index = select_block_type(ctx);

    			if (current_block_type_index === previous_block_index) {
    				if_blocks[current_block_type_index].p(ctx, dirty);
    			} else {
    				group_outros();

    				transition_out(if_blocks[previous_block_index], 1, 1, () => {
    					if_blocks[previous_block_index] = null;
    				});

    				check_outros();
    				if_block0 = if_blocks[current_block_type_index];

    				if (!if_block0) {
    					if_block0 = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx);
    					if_block0.c();
    				} else {
    					if_block0.p(ctx, dirty);
    				}

    				transition_in(if_block0, 1);
    				if_block0.m(section0, null);
    			}

    			if (current_block_type === (current_block_type = select_block_type_2(ctx)) && if_block1) {
    				if_block1.p(ctx, dirty);
    			} else {
    				if_block1.d(1);
    				if_block1 = current_block_type(ctx);

    				if (if_block1) {
    					if_block1.c();
    					if_block1.m(section1, null);
    				}
    			}
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(if_block0);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(if_block0);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(section1);
    			if_blocks[current_block_type_index].d();
    			if_block1.d();
    			mounted = false;
    			dispose();
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment$9.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function instance$9($$self, $$props, $$invalidate) {
    	let account;
    	let $activeAccount;
    	let $accounts;
    	let $translations;
    	validate_store(activeAccount, 'activeAccount');
    	component_subscribe($$self, activeAccount, $$value => $$invalidate(5, $activeAccount = $$value));
    	validate_store(accounts, 'accounts');
    	component_subscribe($$self, accounts, $$value => $$invalidate(6, $accounts = $$value));
    	validate_store(translations, 'translations');
    	component_subscribe($$self, translations, $$value => $$invalidate(3, $translations = $$value));
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('AccountTransactionsList', slots, []);
    	let transSearch = '';

    	function handleClickExportData() {
    		if (account == null) console.log("No account selected");

    		if (account.transactions.length === 0) {
    			notify.set("No transactions to export!");

    			setTimeout(
    				() => {
    					notify.set("");
    				},
    				3500
    			);

    			return;
    		}

    		loading.set(true);

    		fetchNui('ExportData', { account }).then(retval => {
    			console.log(retval);

    			if (retval !== false) {
    				setClipboard(retval);
    			}

    			setTimeout(
    				() => {
    					loading.set(false);
    				},
    				1000
    			);
    		});
    	}

    	let isAtm = false;

    	atm.subscribe(usingAtm => {
    		$$invalidate(1, isAtm = usingAtm);
    	});

    	function handleOrderCard() {
    		orderDetail.update(() => ({ status: true, pin: 1111 }));
    	}

    	function handleCardDetail() {
    		fetchNui('GetCards', {}).then(retData => {
    			loading.set(true);

    			if (retData) {
    				cardsDetail.update(() => ({ status: true, cards: retData }));
    			} else {
    				cardsDetail.update(() => ({ status: true, cards: [] }));
    			}

    			loading.set(false);
    		});
    	}

    	const writable_props = [];

    	Object.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console_1$1.warn(`<AccountTransactionsList> was created with unknown prop '${key}'`);
    	});

    	const func = item => item.message.toLowerCase().includes(transSearch.toLowerCase()) || item.trans_id.toLowerCase().includes(transSearch.toLowerCase()) || item.receiver.toLowerCase().includes(transSearch.toLowerCase());

    	function input_input_handler() {
    		transSearch = this.value;
    		$$invalidate(0, transSearch);
    	}

    	const func_1 = item => item.message.toLowerCase().includes(transSearch.toLowerCase()) || item.trans_id.toLowerCase().includes(transSearch.toLowerCase()) || item.receiver.toLowerCase().includes(transSearch.toLowerCase());

    	$$self.$capture_state = () => ({
    		accounts,
    		activeAccount,
    		translations,
    		atm,
    		notify,
    		orderDetail,
    		cardsDetail,
    		loading,
    		AccountTransactionItem,
    		setClipboard,
    		fetchNui,
    		transSearch,
    		handleClickExportData,
    		isAtm,
    		handleOrderCard,
    		handleCardDetail,
    		account,
    		$activeAccount,
    		$accounts,
    		$translations
    	});

    	$$self.$inject_state = $$props => {
    		if ('transSearch' in $$props) $$invalidate(0, transSearch = $$props.transSearch);
    		if ('isAtm' in $$props) $$invalidate(1, isAtm = $$props.isAtm);
    		if ('account' in $$props) $$invalidate(2, account = $$props.account);
    	};

    	if ($$props && "$$inject" in $$props) {
    		$$self.$inject_state($$props.$$inject);
    	}

    	$$self.$$.update = () => {
    		if ($$self.$$.dirty & /*$accounts, $activeAccount*/ 96) {
    			$$invalidate(2, account = $accounts.find(accountItem => $activeAccount === accountItem.id));
    		}
    	};

    	return [
    		transSearch,
    		isAtm,
    		account,
    		$translations,
    		handleClickExportData,
    		$activeAccount,
    		$accounts,
    		func,
    		input_input_handler,
    		func_1
    	];
    }

    class AccountTransactionsList extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance$9, create_fragment$9, safe_not_equal, {});

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "AccountTransactionsList",
    			options,
    			id: create_fragment$9.name
    		});
    	}
    }

    /* src\components\AccountsContainer.svelte generated by Svelte v3.59.2 */
    const file$8 = "src\\components\\AccountsContainer.svelte";

    function create_fragment$8(ctx) {
    	let div;
    	let section;
    	let accountslist;
    	let t0;
    	let accounttransactionslist;
    	let t1;
    	let h5;
    	let i;
    	let t2_value = formatMoney(/*$accounts*/ ctx[0][0].cash) + "";
    	let t2;
    	let current;
    	accountslist = new AccountsList({ $$inline: true });
    	accounttransactionslist = new AccountTransactionsList({ $$inline: true });

    	const block = {
    		c: function create() {
    			div = element("div");
    			section = element("section");
    			create_component(accountslist.$$.fragment);
    			t0 = space();
    			create_component(accounttransactionslist.$$.fragment);
    			t1 = space();
    			h5 = element("h5");
    			i = element("i");
    			t2 = text(t2_value);
    			attr_dev(section, "class", "svelte-1r0oqyo");
    			add_location(section, file$8, 7, 4, 285);
    			attr_dev(i, "class", "fa-solid fa-wallet fa-fw");
    			add_location(i, file$8, 11, 8, 379);
    			attr_dev(h5, "class", "svelte-1r0oqyo");
    			add_location(h5, file$8, 11, 4, 375);
    			attr_dev(div, "class", "main svelte-1r0oqyo");
    			add_location(div, file$8, 6, 0, 262);
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, div, anchor);
    			append_dev(div, section);
    			mount_component(accountslist, section, null);
    			append_dev(section, t0);
    			mount_component(accounttransactionslist, section, null);
    			append_dev(div, t1);
    			append_dev(div, h5);
    			append_dev(h5, i);
    			append_dev(h5, t2);
    			current = true;
    		},
    		p: function update(ctx, [dirty]) {
    			if ((!current || dirty & /*$accounts*/ 1) && t2_value !== (t2_value = formatMoney(/*$accounts*/ ctx[0][0].cash) + "")) set_data_dev(t2, t2_value);
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(accountslist.$$.fragment, local);
    			transition_in(accounttransactionslist.$$.fragment, local);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(accountslist.$$.fragment, local);
    			transition_out(accounttransactionslist.$$.fragment, local);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(div);
    			destroy_component(accountslist);
    			destroy_component(accounttransactionslist);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment$8.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function instance$8($$self, $$props, $$invalidate) {
    	let $accounts;
    	validate_store(accounts, 'accounts');
    	component_subscribe($$self, accounts, $$value => $$invalidate(0, $accounts = $$value));
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('AccountsContainer', slots, []);
    	const writable_props = [];

    	Object.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console.warn(`<AccountsContainer> was created with unknown prop '${key}'`);
    	});

    	$$self.$capture_state = () => ({
    		AccountsList,
    		AccountTransactionsList,
    		accounts,
    		formatMoney,
    		$accounts
    	});

    	return [$accounts];
    }

    class AccountsContainer extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance$8, create_fragment$8, safe_not_equal, {});

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "AccountsContainer",
    			options,
    			id: create_fragment$8.name
    		});
    	}
    }

    /* src\components\Popup.svelte generated by Svelte v3.59.2 */

    const { Object: Object_1 } = globals;
    const file$7 = "src\\components\\Popup.svelte";

    // (38:12) {#if $popupDetails.actionType === "transfer"}
    function create_if_block$3(ctx) {
    	let div;
    	let label;
    	let t0_value = /*$translations*/ ctx[4].transfer + "";
    	let t0;
    	let t1;
    	let input;
    	let mounted;
    	let dispose;

    	const block = {
    		c: function create() {
    			div = element("div");
    			label = element("label");
    			t0 = text(t0_value);
    			t1 = space();
    			input = element("input");
    			attr_dev(label, "for", "stateId");
    			attr_dev(label, "class", "svelte-1vgnbg7");
    			add_location(label, file$7, 39, 20, 1604);
    			attr_dev(input, "type", "text");
    			attr_dev(input, "name", "stateId");
    			attr_dev(input, "id", "stateId");
    			attr_dev(input, "placeholder", "#");
    			attr_dev(input, "class", "svelte-1vgnbg7");
    			add_location(input, file$7, 40, 20, 1678);
    			attr_dev(div, "class", "form-row svelte-1vgnbg7");
    			add_location(div, file$7, 38, 16, 1561);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, div, anchor);
    			append_dev(div, label);
    			append_dev(label, t0);
    			append_dev(div, t1);
    			append_dev(div, input);
    			set_input_value(input, /*stateid*/ ctx[2]);

    			if (!mounted) {
    				dispose = listen_dev(input, "input", /*input_input_handler*/ ctx[11]);
    				mounted = true;
    			}
    		},
    		p: function update(ctx, dirty) {
    			if (dirty & /*$translations*/ 16 && t0_value !== (t0_value = /*$translations*/ ctx[4].transfer + "")) set_data_dev(t0, t0_value);

    			if (dirty & /*stateid*/ 4 && input.value !== /*stateid*/ ctx[2]) {
    				set_input_value(input, /*stateid*/ ctx[2]);
    			}
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(div);
    			mounted = false;
    			dispose();
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block$3.name,
    		type: "if",
    		source: "(38:12) {#if $popupDetails.actionType === \\\"transfer\\\"}",
    		ctx
    	});

    	return block;
    }

    function create_fragment$7(ctx) {
    	let section1;
    	let section0;
    	let h2;
    	let t0_value = /*$popupDetails*/ ctx[3].account.type + "";
    	let t0;
    	let t1_value = /*$translations*/ ctx[4].account + "";
    	let t1;
    	let t2;
    	let t3_value = /*$popupDetails*/ ctx[3].account.id + "";
    	let t3;
    	let t4;
    	let form;
    	let div0;
    	let label0;
    	let t5_value = /*$translations*/ ctx[4].amount + "";
    	let t5;
    	let t6;
    	let input0;
    	let t7;
    	let div1;
    	let label1;
    	let t8_value = /*$translations*/ ctx[4].comment + "";
    	let t8;
    	let t9;
    	let input1;
    	let t10;
    	let t11;
    	let div2;
    	let button0;
    	let t12_value = /*$translations*/ ctx[4].cancel + "";
    	let t12;
    	let t13;
    	let button1;
    	let t14_value = /*$translations*/ ctx[4].confirm + "";
    	let t14;
    	let mounted;
    	let dispose;
    	let if_block = /*$popupDetails*/ ctx[3].actionType === "transfer" && create_if_block$3(ctx);

    	const block = {
    		c: function create() {
    			section1 = element("section");
    			section0 = element("section");
    			h2 = element("h2");
    			t0 = text(t0_value);
    			t1 = text(t1_value);
    			t2 = text("/ ");
    			t3 = text(t3_value);
    			t4 = space();
    			form = element("form");
    			div0 = element("div");
    			label0 = element("label");
    			t5 = text(t5_value);
    			t6 = space();
    			input0 = element("input");
    			t7 = space();
    			div1 = element("div");
    			label1 = element("label");
    			t8 = text(t8_value);
    			t9 = space();
    			input1 = element("input");
    			t10 = space();
    			if (if_block) if_block.c();
    			t11 = space();
    			div2 = element("div");
    			button0 = element("button");
    			t12 = text(t12_value);
    			t13 = space();
    			button1 = element("button");
    			t14 = text(t14_value);
    			attr_dev(h2, "class", "svelte-1vgnbg7");
    			add_location(h2, file$7, 25, 8, 919);
    			attr_dev(label0, "for", "amount");
    			attr_dev(label0, "class", "svelte-1vgnbg7");
    			add_location(label0, file$7, 28, 16, 1086);
    			attr_dev(input0, "type", "number");
    			attr_dev(input0, "name", "amount");
    			attr_dev(input0, "id", "amount");
    			attr_dev(input0, "placeholder", "$");
    			attr_dev(input0, "class", "svelte-1vgnbg7");
    			add_location(input0, file$7, 29, 16, 1153);
    			attr_dev(div0, "class", "form-row svelte-1vgnbg7");
    			add_location(div0, file$7, 27, 12, 1047);
    			attr_dev(label1, "for", "comment");
    			attr_dev(label1, "class", "svelte-1vgnbg7");
    			add_location(label1, file$7, 33, 16, 1310);
    			attr_dev(input1, "type", "text");
    			attr_dev(input1, "name", "comment");
    			attr_dev(input1, "id", "comment");
    			attr_dev(input1, "placeholder", "//");
    			attr_dev(input1, "class", "svelte-1vgnbg7");
    			add_location(input1, file$7, 34, 16, 1379);
    			attr_dev(div1, "class", "form-row svelte-1vgnbg7");
    			add_location(div1, file$7, 32, 12, 1271);
    			attr_dev(button0, "type", "button");
    			attr_dev(button0, "class", "btn btn-red");
    			add_location(button0, file$7, 45, 16, 1860);
    			attr_dev(button1, "type", "button");
    			attr_dev(button1, "class", "btn btn-green");
    			add_location(button1, file$7, 46, 16, 1972);
    			attr_dev(div2, "class", "btns-group");
    			add_location(div2, file$7, 44, 12, 1819);
    			attr_dev(form, "action", "#");
    			add_location(form, file$7, 26, 8, 1017);
    			attr_dev(section0, "class", "popup-content svelte-1vgnbg7");
    			add_location(section0, file$7, 24, 4, 879);
    			attr_dev(section1, "class", "popup-container svelte-1vgnbg7");
    			add_location(section1, file$7, 23, 0, 841);
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, section1, anchor);
    			append_dev(section1, section0);
    			append_dev(section0, h2);
    			append_dev(h2, t0);
    			append_dev(h2, t1);
    			append_dev(h2, t2);
    			append_dev(h2, t3);
    			append_dev(section0, t4);
    			append_dev(section0, form);
    			append_dev(form, div0);
    			append_dev(div0, label0);
    			append_dev(label0, t5);
    			append_dev(div0, t6);
    			append_dev(div0, input0);
    			set_input_value(input0, /*amount*/ ctx[0]);
    			append_dev(form, t7);
    			append_dev(form, div1);
    			append_dev(div1, label1);
    			append_dev(label1, t8);
    			append_dev(div1, t9);
    			append_dev(div1, input1);
    			set_input_value(input1, /*comment*/ ctx[1]);
    			append_dev(form, t10);
    			if (if_block) if_block.m(form, null);
    			append_dev(form, t11);
    			append_dev(form, div2);
    			append_dev(div2, button0);
    			append_dev(button0, t12);
    			append_dev(div2, t13);
    			append_dev(div2, button1);
    			append_dev(button1, t14);

    			if (!mounted) {
    				dispose = [
    					listen_dev(input0, "input", /*input0_input_handler*/ ctx[9]),
    					listen_dev(input1, "input", /*input1_input_handler*/ ctx[10]),
    					listen_dev(button0, "click", /*closePopup*/ ctx[5], false, false, false, false),
    					listen_dev(button1, "click", /*click_handler*/ ctx[12], false, false, false, false)
    				];

    				mounted = true;
    			}
    		},
    		p: function update(ctx, [dirty]) {
    			if (dirty & /*$popupDetails*/ 8 && t0_value !== (t0_value = /*$popupDetails*/ ctx[3].account.type + "")) set_data_dev(t0, t0_value);
    			if (dirty & /*$translations*/ 16 && t1_value !== (t1_value = /*$translations*/ ctx[4].account + "")) set_data_dev(t1, t1_value);
    			if (dirty & /*$popupDetails*/ 8 && t3_value !== (t3_value = /*$popupDetails*/ ctx[3].account.id + "")) set_data_dev(t3, t3_value);
    			if (dirty & /*$translations*/ 16 && t5_value !== (t5_value = /*$translations*/ ctx[4].amount + "")) set_data_dev(t5, t5_value);

    			if (dirty & /*amount*/ 1 && to_number(input0.value) !== /*amount*/ ctx[0]) {
    				set_input_value(input0, /*amount*/ ctx[0]);
    			}

    			if (dirty & /*$translations*/ 16 && t8_value !== (t8_value = /*$translations*/ ctx[4].comment + "")) set_data_dev(t8, t8_value);

    			if (dirty & /*comment*/ 2 && input1.value !== /*comment*/ ctx[1]) {
    				set_input_value(input1, /*comment*/ ctx[1]);
    			}

    			if (/*$popupDetails*/ ctx[3].actionType === "transfer") {
    				if (if_block) {
    					if_block.p(ctx, dirty);
    				} else {
    					if_block = create_if_block$3(ctx);
    					if_block.c();
    					if_block.m(form, t11);
    				}
    			} else if (if_block) {
    				if_block.d(1);
    				if_block = null;
    			}

    			if (dirty & /*$translations*/ 16 && t12_value !== (t12_value = /*$translations*/ ctx[4].cancel + "")) set_data_dev(t12, t12_value);
    			if (dirty & /*$translations*/ 16 && t14_value !== (t14_value = /*$translations*/ ctx[4].confirm + "")) set_data_dev(t14, t14_value);
    		},
    		i: noop,
    		o: noop,
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(section1);
    			if (if_block) if_block.d();
    			mounted = false;
    			run_all(dispose);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment$7.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function instance$7($$self, $$props, $$invalidate) {
    	let account;
    	let $popupDetails;
    	let $activeAccount;
    	let $accounts;
    	let $translations;
    	validate_store(popupDetails, 'popupDetails');
    	component_subscribe($$self, popupDetails, $$value => $$invalidate(3, $popupDetails = $$value));
    	validate_store(activeAccount, 'activeAccount');
    	component_subscribe($$self, activeAccount, $$value => $$invalidate(7, $activeAccount = $$value));
    	validate_store(accounts, 'accounts');
    	component_subscribe($$self, accounts, $$value => $$invalidate(8, $accounts = $$value));
    	validate_store(translations, 'translations');
    	component_subscribe($$self, translations, $$value => $$invalidate(4, $translations = $$value));
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('Popup', slots, []);
    	let amount = 0;
    	let comment = "";
    	let stateid = "";

    	function closePopup() {
    		popupDetails.update(val => Object.assign(Object.assign({}, val), { actionType: "" }));
    	}

    	function submitInput() {
    		loading.set(true);

    		fetchNui($popupDetails.actionType, {
    			fromAccount: $popupDetails.account.id,
    			amount,
    			comment,
    			stateid
    		}).then(retData => {
    			setTimeout(
    				() => {
    					if (retData !== false) {
    						accounts.set(retData);
    					}

    					loading.set(false);
    				},
    				1000
    			);
    		});

    		closePopup();
    	}

    	const writable_props = [];

    	Object_1.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console.warn(`<Popup> was created with unknown prop '${key}'`);
    	});

    	function input0_input_handler() {
    		amount = to_number(this.value);
    		$$invalidate(0, amount);
    	}

    	function input1_input_handler() {
    		comment = this.value;
    		$$invalidate(1, comment);
    	}

    	function input_input_handler() {
    		stateid = this.value;
    		$$invalidate(2, stateid);
    	}

    	const click_handler = () => submitInput();

    	$$self.$capture_state = () => ({
    		accounts,
    		activeAccount,
    		popupDetails,
    		loading,
    		translations,
    		fetchNui,
    		amount,
    		comment,
    		stateid,
    		closePopup,
    		submitInput,
    		account,
    		$popupDetails,
    		$activeAccount,
    		$accounts,
    		$translations
    	});

    	$$self.$inject_state = $$props => {
    		if ('amount' in $$props) $$invalidate(0, amount = $$props.amount);
    		if ('comment' in $$props) $$invalidate(1, comment = $$props.comment);
    		if ('stateid' in $$props) $$invalidate(2, stateid = $$props.stateid);
    		if ('account' in $$props) account = $$props.account;
    	};

    	if ($$props && "$$inject" in $$props) {
    		$$self.$inject_state($$props.$$inject);
    	}

    	$$self.$$.update = () => {
    		if ($$self.$$.dirty & /*$accounts, $activeAccount*/ 384) {
    			account = $accounts.find(accountItem => $activeAccount === accountItem.id);
    		}
    	};

    	return [
    		amount,
    		comment,
    		stateid,
    		$popupDetails,
    		$translations,
    		closePopup,
    		submitInput,
    		$activeAccount,
    		$accounts,
    		input0_input_handler,
    		input1_input_handler,
    		input_input_handler,
    		click_handler
    	];
    }

    class Popup extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance$7, create_fragment$7, safe_not_equal, {});

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "Popup",
    			options,
    			id: create_fragment$7.name
    		});
    	}
    }

    /* src\components\Loading.svelte generated by Svelte v3.59.2 */

    const file$6 = "src\\components\\Loading.svelte";

    function create_fragment$6(ctx) {
    	let section1;
    	let section0;
    	let div12;
    	let div0;
    	let t0;
    	let div1;
    	let t1;
    	let div2;
    	let t2;
    	let div3;
    	let t3;
    	let div4;
    	let t4;
    	let div5;
    	let t5;
    	let div6;
    	let t6;
    	let div7;
    	let t7;
    	let div8;
    	let t8;
    	let div9;
    	let t9;
    	let div10;
    	let t10;
    	let div11;

    	const block = {
    		c: function create() {
    			section1 = element("section");
    			section0 = element("section");
    			div12 = element("div");
    			div0 = element("div");
    			t0 = space();
    			div1 = element("div");
    			t1 = space();
    			div2 = element("div");
    			t2 = space();
    			div3 = element("div");
    			t3 = space();
    			div4 = element("div");
    			t4 = space();
    			div5 = element("div");
    			t5 = space();
    			div6 = element("div");
    			t6 = space();
    			div7 = element("div");
    			t7 = space();
    			div8 = element("div");
    			t8 = space();
    			div9 = element("div");
    			t9 = space();
    			div10 = element("div");
    			t10 = space();
    			div11 = element("div");
    			attr_dev(div0, "class", "svelte-1dy70p0");
    			add_location(div0, file$6, 3, 12, 124);
    			attr_dev(div1, "class", "svelte-1dy70p0");
    			add_location(div1, file$6, 4, 12, 148);
    			attr_dev(div2, "class", "svelte-1dy70p0");
    			add_location(div2, file$6, 5, 12, 172);
    			attr_dev(div3, "class", "svelte-1dy70p0");
    			add_location(div3, file$6, 6, 12, 196);
    			attr_dev(div4, "class", "svelte-1dy70p0");
    			add_location(div4, file$6, 7, 12, 220);
    			attr_dev(div5, "class", "svelte-1dy70p0");
    			add_location(div5, file$6, 8, 12, 244);
    			attr_dev(div6, "class", "svelte-1dy70p0");
    			add_location(div6, file$6, 9, 12, 268);
    			attr_dev(div7, "class", "svelte-1dy70p0");
    			add_location(div7, file$6, 10, 12, 292);
    			attr_dev(div8, "class", "svelte-1dy70p0");
    			add_location(div8, file$6, 11, 12, 316);
    			attr_dev(div9, "class", "svelte-1dy70p0");
    			add_location(div9, file$6, 12, 12, 340);
    			attr_dev(div10, "class", "svelte-1dy70p0");
    			add_location(div10, file$6, 13, 12, 364);
    			attr_dev(div11, "class", "svelte-1dy70p0");
    			add_location(div11, file$6, 14, 12, 388);
    			attr_dev(div12, "class", "loading-spinner svelte-1dy70p0");
    			add_location(div12, file$6, 2, 8, 82);
    			attr_dev(section0, "class", "loading-content svelte-1dy70p0");
    			add_location(section0, file$6, 1, 4, 40);
    			attr_dev(section1, "class", "loading-container svelte-1dy70p0");
    			add_location(section1, file$6, 0, 0, 0);
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, section1, anchor);
    			append_dev(section1, section0);
    			append_dev(section0, div12);
    			append_dev(div12, div0);
    			append_dev(div12, t0);
    			append_dev(div12, div1);
    			append_dev(div12, t1);
    			append_dev(div12, div2);
    			append_dev(div12, t2);
    			append_dev(div12, div3);
    			append_dev(div12, t3);
    			append_dev(div12, div4);
    			append_dev(div12, t4);
    			append_dev(div12, div5);
    			append_dev(div12, t5);
    			append_dev(div12, div6);
    			append_dev(div12, t6);
    			append_dev(div12, div7);
    			append_dev(div12, t7);
    			append_dev(div12, div8);
    			append_dev(div12, t8);
    			append_dev(div12, div9);
    			append_dev(div12, t9);
    			append_dev(div12, div10);
    			append_dev(div12, t10);
    			append_dev(div12, div11);
    		},
    		p: noop,
    		i: noop,
    		o: noop,
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(section1);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment$6.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function instance$6($$self, $$props) {
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('Loading', slots, []);
    	const writable_props = [];

    	Object.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console.warn(`<Loading> was created with unknown prop '${key}'`);
    	});

    	return [];
    }

    class Loading extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance$6, create_fragment$6, safe_not_equal, {});

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "Loading",
    			options,
    			id: create_fragment$6.name
    		});
    	}
    }

    /* src\components\Notification.svelte generated by Svelte v3.59.2 */
    const file$5 = "src\\components\\Notification.svelte";

    function create_fragment$5(ctx) {
    	let section1;
    	let section0;
    	let i;
    	let t0;
    	let strong;
    	let t1;

    	const block = {
    		c: function create() {
    			section1 = element("section");
    			section0 = element("section");
    			i = element("i");
    			t0 = space();
    			strong = element("strong");
    			t1 = text(/*$notify*/ ctx[0]);
    			attr_dev(i, "class", "start-icon fa fa-info-circle faa-shake animated fa-2x");
    			add_location(i, file$5, 6, 8, 156);
    			attr_dev(strong, "class", "font__weight-bold");
    			set_style(strong, "font-size", "0.69vw");
    			add_location(strong, file$5, 7, 8, 233);
    			attr_dev(section0, "class", "notificaion-content svelte-uno730");
    			add_location(section0, file$5, 5, 4, 110);
    			attr_dev(section1, "class", "notificaion-container svelte-uno730");
    			add_location(section1, file$5, 4, 0, 66);
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, section1, anchor);
    			append_dev(section1, section0);
    			append_dev(section0, i);
    			append_dev(section0, t0);
    			append_dev(section0, strong);
    			append_dev(strong, t1);
    		},
    		p: function update(ctx, [dirty]) {
    			if (dirty & /*$notify*/ 1) set_data_dev(t1, /*$notify*/ ctx[0]);
    		},
    		i: noop,
    		o: noop,
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(section1);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment$5.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function instance$5($$self, $$props, $$invalidate) {
    	let $notify;
    	validate_store(notify, 'notify');
    	component_subscribe($$self, notify, $$value => $$invalidate(0, $notify = $$value));
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('Notification', slots, []);
    	const writable_props = [];

    	Object.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console.warn(`<Notification> was created with unknown prop '${key}'`);
    	});

    	$$self.$capture_state = () => ({ notify, $notify });
    	return [$notify];
    }

    class Notification extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance$5, create_fragment$5, safe_not_equal, {});

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "Notification",
    			options,
    			id: create_fragment$5.name
    		});
    	}
    }

    /* src\components\order.svelte generated by Svelte v3.59.2 */
    const file$4 = "src\\components\\order.svelte";

    function create_fragment$4(ctx) {
    	let section1;
    	let section0;
    	let h2;
    	let t1;
    	let form;
    	let div0;
    	let label;
    	let t3;
    	let input;
    	let t4;
    	let div1;
    	let button0;
    	let t6;
    	let button1;
    	let mounted;
    	let dispose;

    	const block = {
    		c: function create() {
    			section1 = element("section");
    			section0 = element("section");
    			h2 = element("h2");
    			h2.textContent = "ORDER CARD for $5000";
    			t1 = space();
    			form = element("form");
    			div0 = element("div");
    			label = element("label");
    			label.textContent = "Enter pin Code";
    			t3 = space();
    			input = element("input");
    			t4 = space();
    			div1 = element("div");
    			button0 = element("button");
    			button0.textContent = "Cancle Order";
    			t6 = space();
    			button1 = element("button");
    			button1.textContent = "Order Now";
    			attr_dev(h2, "class", "svelte-1vgnbg7");
    			add_location(h2, file$4, 58, 4, 1726);
    			attr_dev(label, "for", "amount");
    			attr_dev(label, "class", "svelte-1vgnbg7");
    			add_location(label, file$4, 61, 12, 1824);
    			attr_dev(input, "type", "password");
    			attr_dev(input, "name", "pin");
    			attr_dev(input, "id", "pin");
    			attr_dev(input, "placeholder", "Enter Code");
    			attr_dev(input, "maxlength", "4");
    			attr_dev(input, "class", "svelte-1vgnbg7");
    			add_location(input, file$4, 62, 12, 1880);
    			attr_dev(div0, "class", "form-row svelte-1vgnbg7");
    			add_location(div0, file$4, 60, 8, 1788);
    			attr_dev(button0, "type", "button");
    			attr_dev(button0, "class", "btn btn-red");
    			add_location(button0, file$4, 66, 12, 2046);
    			attr_dev(button1, "type", "button");
    			attr_dev(button1, "class", "btn btn-green");
    			add_location(button1, file$4, 67, 12, 2145);
    			attr_dev(div1, "class", "btns-group");
    			add_location(div1, file$4, 65, 8, 2008);
    			attr_dev(form, "action", "#");
    			add_location(form, file$4, 59, 4, 1761);
    			attr_dev(section0, "class", "popup-content svelte-1vgnbg7");
    			add_location(section0, file$4, 57, 4, 1689);
    			attr_dev(section1, "class", "popup-container svelte-1vgnbg7");
    			add_location(section1, file$4, 56, 0, 1650);
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, section1, anchor);
    			append_dev(section1, section0);
    			append_dev(section0, h2);
    			append_dev(section0, t1);
    			append_dev(section0, form);
    			append_dev(form, div0);
    			append_dev(div0, label);
    			append_dev(div0, t3);
    			append_dev(div0, input);
    			set_input_value(input, /*pin*/ ctx[0]);
    			append_dev(form, t4);
    			append_dev(form, div1);
    			append_dev(div1, button0);
    			append_dev(div1, t6);
    			append_dev(div1, button1);

    			if (!mounted) {
    				dispose = [
    					listen_dev(input, "input", /*input_input_handler*/ ctx[3]),
    					listen_dev(button0, "click", /*CloseOrder*/ ctx[1], false, false, false, false),
    					listen_dev(button1, "click", /*click_handler*/ ctx[4], false, false, false, false)
    				];

    				mounted = true;
    			}
    		},
    		p: function update(ctx, [dirty]) {
    			if (dirty & /*pin*/ 1 && input.value !== /*pin*/ ctx[0]) {
    				set_input_value(input, /*pin*/ ctx[0]);
    			}
    		},
    		i: noop,
    		o: noop,
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(section1);
    			mounted = false;
    			run_all(dispose);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment$4.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function isOnlyNumbers(input) {
    	const regex = /^[0-9]+$/;
    	return regex.test(input);
    }

    function instance$4($$self, $$props, $$invalidate) {
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('Order', slots, []);
    	let pin;

    	function CloseOrder() {
    		orderDetail.update(() => ({ status: false, pin: 0 }));
    	}

    	function submitInputOrder() {
    		if (pin !== undefined) {
    			if (isOnlyNumbers(pin)) {
    				const strNum = pin.toString();
    				const digitCount = strNum.length;

    				if (digitCount === 4) {
    					loading.set(true);

    					fetchNui('Order', { pin }).then(retData => {
    						if (retData !== '' && retData !== true) {
    							notify.set(retData);

    							setTimeout(
    								() => {
    									notify.set("");
    								},
    								3500
    							);
    						}

    						setTimeout(
    							() => {
    								loading.set(false);
    							},
    							1000
    						);
    					});

    					CloseOrder();
    				} else {
    					notify.set("Enter 4 digit code only");

    					setTimeout(
    						() => {
    							notify.set("");
    						},
    						3500
    					);
    				}
    			} else {
    				notify.set("Only 0 to 9 number supported");

    				setTimeout(
    					() => {
    						notify.set("");
    					},
    					3500
    				);
    			}
    		} else {
    			notify.set("Enter 4 digit code");

    			setTimeout(
    				() => {
    					notify.set("");
    				},
    				3500
    			);
    		}
    	}

    	const writable_props = [];

    	Object.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console.warn(`<Order> was created with unknown prop '${key}'`);
    	});

    	function input_input_handler() {
    		pin = this.value;
    		$$invalidate(0, pin);
    	}

    	const click_handler = () => submitInputOrder();

    	$$self.$capture_state = () => ({
    		loading,
    		notify,
    		orderDetail,
    		fetchNui,
    		pin,
    		CloseOrder,
    		isOnlyNumbers,
    		submitInputOrder
    	});

    	$$self.$inject_state = $$props => {
    		if ('pin' in $$props) $$invalidate(0, pin = $$props.pin);
    	};

    	if ($$props && "$$inject" in $$props) {
    		$$self.$inject_state($$props.$$inject);
    	}

    	return [pin, CloseOrder, submitInputOrder, input_input_handler, click_handler];
    }

    class Order extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance$4, create_fragment$4, safe_not_equal, {});

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "Order",
    			options,
    			id: create_fragment$4.name
    		});
    	}
    }

    /* src\components\cards.svelte generated by Svelte v3.59.2 */

    const { console: console_1 } = globals;
    const file$3 = "src\\components\\cards.svelte";

    function get_each_context$1(ctx, list, i) {
    	const child_ctx = ctx.slice();
    	child_ctx[9] = list[i];
    	return child_ctx;
    }

    // (86:12) {:else}
    function create_else_block_1(ctx) {
    	let h2;
    	let t1;
    	let div;
    	let button;
    	let mounted;
    	let dispose;

    	const block = {
    		c: function create() {
    			h2 = element("h2");
    			h2.textContent = "It seems like you don't have a card order 1 now";
    			t1 = space();
    			div = element("div");
    			button = element("button");
    			button.textContent = "Order Now";
    			attr_dev(h2, "class", "svelte-wd50zt");
    			add_location(h2, file$3, 86, 16, 3311);
    			attr_dev(button, "type", "button");
    			attr_dev(button, "class", "btn btn-green");
    			add_location(button, file$3, 88, 20, 3431);
    			attr_dev(div, "class", "btns-group");
    			add_location(div, file$3, 87, 16, 3385);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, h2, anchor);
    			insert_dev(target, t1, anchor);
    			insert_dev(target, div, anchor);
    			append_dev(div, button);

    			if (!mounted) {
    				dispose = listen_dev(button, "click", /*handleordercard*/ ctx[4], false, false, false, false);
    				mounted = true;
    			}
    		},
    		p: noop,
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(h2);
    			if (detaching) detach_dev(t1);
    			if (detaching) detach_dev(div);
    			mounted = false;
    			dispose();
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_else_block_1.name,
    		type: "else",
    		source: "(86:12) {:else}",
    		ctx
    	});

    	return block;
    }

    // (69:12) {#if $cardsDetail.cards.length > 0}
    function create_if_block$2(ctx) {
    	let h2;
    	let t1;
    	let div1;
    	let div0;
    	let each_value = /*$cardsDetail*/ ctx[0].cards;
    	validate_each_argument(each_value);
    	let each_blocks = [];

    	for (let i = 0; i < each_value.length; i += 1) {
    		each_blocks[i] = create_each_block$1(get_each_context$1(ctx, each_value, i));
    	}

    	const block = {
    		c: function create() {
    			h2 = element("h2");
    			h2.textContent = "Your Cards";
    			t1 = space();
    			div1 = element("div");
    			div0 = element("div");

    			for (let i = 0; i < each_blocks.length; i += 1) {
    				each_blocks[i].c();
    			}

    			attr_dev(h2, "class", "svelte-wd50zt");
    			add_location(h2, file$3, 69, 16, 2196);
    			attr_dev(div0, "class", "btns-group2 svelte-wd50zt");
    			add_location(div0, file$3, 71, 20, 2278);
    			attr_dev(div1, "class", "form-row  svelte-wd50zt");
    			add_location(div1, file$3, 70, 16, 2233);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, h2, anchor);
    			insert_dev(target, t1, anchor);
    			insert_dev(target, div1, anchor);
    			append_dev(div1, div0);

    			for (let i = 0; i < each_blocks.length; i += 1) {
    				if (each_blocks[i]) {
    					each_blocks[i].m(div0, null);
    				}
    			}
    		},
    		p: function update(ctx, dirty) {
    			if (dirty & /*DeleteCard, $cardsDetail, UpdateCard, formatCardNumber*/ 13) {
    				each_value = /*$cardsDetail*/ ctx[0].cards;
    				validate_each_argument(each_value);
    				let i;

    				for (i = 0; i < each_value.length; i += 1) {
    					const child_ctx = get_each_context$1(ctx, each_value, i);

    					if (each_blocks[i]) {
    						each_blocks[i].p(child_ctx, dirty);
    					} else {
    						each_blocks[i] = create_each_block$1(child_ctx);
    						each_blocks[i].c();
    						each_blocks[i].m(div0, null);
    					}
    				}

    				for (; i < each_blocks.length; i += 1) {
    					each_blocks[i].d(1);
    				}

    				each_blocks.length = each_value.length;
    			}
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(h2);
    			if (detaching) detach_dev(t1);
    			if (detaching) detach_dev(div1);
    			destroy_each(each_blocks, detaching);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block$2.name,
    		type: "if",
    		source: "(69:12) {#if $cardsDetail.cards.length > 0}",
    		ctx
    	});

    	return block;
    }

    // (77:36) {:else}
    function create_else_block$1(ctx) {
    	let button;
    	let mounted;
    	let dispose;

    	function click_handler_1() {
    		return /*click_handler_1*/ ctx[6](/*car*/ ctx[9]);
    	}

    	const block = {
    		c: function create() {
    			button = element("button");
    			button.textContent = "Unblock Card";
    			attr_dev(button, "type", "button");
    			attr_dev(button, "class", "btn btn-green");
    			set_style(button, "margin-top", "1.5vh");
    			add_location(button, file$3, 77, 40, 2785);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, button, anchor);

    			if (!mounted) {
    				dispose = listen_dev(button, "click", click_handler_1, false, false, false, false);
    				mounted = true;
    			}
    		},
    		p: function update(new_ctx, dirty) {
    			ctx = new_ctx;
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(button);
    			mounted = false;
    			dispose();
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_else_block$1.name,
    		type: "else",
    		source: "(77:36) {:else}",
    		ctx
    	});

    	return block;
    }

    // (75:36) {#if car.blocked == 0}
    function create_if_block_1$1(ctx) {
    	let button;
    	let mounted;
    	let dispose;

    	function click_handler() {
    		return /*click_handler*/ ctx[5](/*car*/ ctx[9]);
    	}

    	const block = {
    		c: function create() {
    			button = element("button");
    			button.textContent = "Block Card";
    			attr_dev(button, "type", "button");
    			attr_dev(button, "class", "btn btn-orange");
    			set_style(button, "margin-top", "1.5vh");
    			add_location(button, file$3, 75, 40, 2571);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, button, anchor);

    			if (!mounted) {
    				dispose = listen_dev(button, "click", click_handler, false, false, false, false);
    				mounted = true;
    			}
    		},
    		p: function update(new_ctx, dirty) {
    			ctx = new_ctx;
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(button);
    			mounted = false;
    			dispose();
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block_1$1.name,
    		type: "if",
    		source: "(75:36) {#if car.blocked == 0}",
    		ctx
    	});

    	return block;
    }

    // (73:28) {#each $cardsDetail.cards as car}
    function create_each_block$1(ctx) {
    	let div;
    	let t0;
    	let t1_value = formatCardNumber$1(/*car*/ ctx[9].card) + "";
    	let t1;
    	let t2;
    	let t3;
    	let button;
    	let t5;
    	let mounted;
    	let dispose;

    	function select_block_type_1(ctx, dirty) {
    		if (/*car*/ ctx[9].blocked == 0) return create_if_block_1$1;
    		return create_else_block$1;
    	}

    	let current_block_type = select_block_type_1(ctx);
    	let if_block = current_block_type(ctx);

    	function click_handler_2() {
    		return /*click_handler_2*/ ctx[7](/*car*/ ctx[9]);
    	}

    	const block = {
    		c: function create() {
    			div = element("div");
    			t0 = text("Card Number: ");
    			t1 = text(t1_value);
    			t2 = space();
    			if_block.c();
    			t3 = space();
    			button = element("button");
    			button.textContent = "Delete Card";
    			t5 = space();
    			attr_dev(button, "type", "button");
    			attr_dev(button, "class", "btn btn-red");
    			add_location(button, file$3, 79, 36, 2994);
    			attr_dev(div, "class", "btns-group dev svelte-wd50zt");
    			add_location(div, file$3, 73, 32, 2400);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, div, anchor);
    			append_dev(div, t0);
    			append_dev(div, t1);
    			append_dev(div, t2);
    			if_block.m(div, null);
    			append_dev(div, t3);
    			append_dev(div, button);
    			append_dev(div, t5);

    			if (!mounted) {
    				dispose = listen_dev(button, "click", click_handler_2, false, false, false, false);
    				mounted = true;
    			}
    		},
    		p: function update(new_ctx, dirty) {
    			ctx = new_ctx;
    			if (dirty & /*$cardsDetail*/ 1 && t1_value !== (t1_value = formatCardNumber$1(/*car*/ ctx[9].card) + "")) set_data_dev(t1, t1_value);

    			if (current_block_type === (current_block_type = select_block_type_1(ctx)) && if_block) {
    				if_block.p(ctx, dirty);
    			} else {
    				if_block.d(1);
    				if_block = current_block_type(ctx);

    				if (if_block) {
    					if_block.c();
    					if_block.m(div, t3);
    				}
    			}
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(div);
    			if_block.d();
    			mounted = false;
    			dispose();
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_each_block$1.name,
    		type: "each",
    		source: "(73:28) {#each $cardsDetail.cards as car}",
    		ctx
    	});

    	return block;
    }

    function create_fragment$3(ctx) {
    	let section1;
    	let section0;
    	let button;
    	let t1;
    	let mounted;
    	let dispose;

    	function select_block_type(ctx, dirty) {
    		if (/*$cardsDetail*/ ctx[0].cards.length > 0) return create_if_block$2;
    		return create_else_block_1;
    	}

    	let current_block_type = select_block_type(ctx);
    	let if_block = current_block_type(ctx);

    	const block = {
    		c: function create() {
    			section1 = element("section");
    			section0 = element("section");
    			button = element("button");
    			button.textContent = "Close";
    			t1 = space();
    			if_block.c();
    			attr_dev(button, "type", "button");
    			attr_dev(button, "class", "btn btn-red");
    			add_location(button, file$3, 67, 12, 2051);
    			attr_dev(section0, "class", "popup-content scroller2 svelte-wd50zt");
    			add_location(section0, file$3, 66, 4, 1996);
    			attr_dev(section1, "class", "popup-container svelte-wd50zt");
    			add_location(section1, file$3, 65, 0, 1957);
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, section1, anchor);
    			append_dev(section1, section0);
    			append_dev(section0, button);
    			append_dev(section0, t1);
    			if_block.m(section0, null);

    			if (!mounted) {
    				dispose = listen_dev(button, "click", /*CloseCards*/ ctx[1], false, false, false, false);
    				mounted = true;
    			}
    		},
    		p: function update(ctx, [dirty]) {
    			if (current_block_type === (current_block_type = select_block_type(ctx)) && if_block) {
    				if_block.p(ctx, dirty);
    			} else {
    				if_block.d(1);
    				if_block = current_block_type(ctx);

    				if (if_block) {
    					if_block.c();
    					if_block.m(section0, null);
    				}
    			}
    		},
    		i: noop,
    		o: noop,
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(section1);
    			if_block.d();
    			mounted = false;
    			dispose();
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment$3.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function formatCardNumber$1(input) {
    	var _a;

    	let formatted = ((_a = input.match(/.{1,4}/g)) === null || _a === void 0
    	? void 0
    	: _a.join(' ')) || '';

    	return formatted;
    }

    function instance$3($$self, $$props, $$invalidate) {
    	let $cardsDetail;
    	validate_store(cardsDetail, 'cardsDetail');
    	component_subscribe($$self, cardsDetail, $$value => $$invalidate(0, $cardsDetail = $$value));
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('Cards', slots, []);

    	function CloseCards() {
    		cardsDetail.update(() => ({ status: false, cards: [] }));
    	}

    	function UpdateCard(id) {
    		CloseCards();
    		loading.set(true);

    		fetchNui('UpdateCard', { id }).then(retval => {
    			if (retval !== '' && retval !== true) {
    				notify.set(retval);

    				setTimeout(
    					() => {
    						notify.set("");
    					},
    					3500
    				);
    			}

    			setTimeout(
    				() => {
    					loading.set(false);
    				},
    				1000
    			);
    		});
    	}

    	function DeleteCard(id, limit, maxlimit) {
    		console.log(id);

    		// if (limit >= maxlimit){
    		CloseCards();

    		loading.set(true);

    		fetchNui('DeleteCard', { id }).then(retval => {
    			if (retval !== '' && retval !== true) {
    				notify.set(retval);

    				setTimeout(
    					() => {
    						notify.set("");
    					},
    					3500
    				);
    			}

    			setTimeout(
    				() => {
    					loading.set(false);
    				},
    				1000
    			);
    		});
    	} // } else {
    	//     notify.set("Try Again letter when card usage is 0%");

    	//     setTimeout(() => {
    	//         notify.set("");
    	//     }, 3500);
    	// }
    	function handleordercard() {
    		CloseCards();
    		orderDetail.update(() => ({ status: true, pin: 1111 }));
    	}

    	const formatMoney = amount => {
    		let formattedAmount = amount.toString();
    		const parts = formattedAmount.split('.');
    		let integerPart = parts[0];
    		const decimalPart = parts.length > 1 ? '.' + parts[1] : '';
    		integerPart = integerPart.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    		return integerPart + decimalPart;
    	};

    	const writable_props = [];

    	Object.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console_1.warn(`<Cards> was created with unknown prop '${key}'`);
    	});

    	const click_handler = car => UpdateCard(car.id);
    	const click_handler_1 = car => UpdateCard(car.id);
    	const click_handler_2 = car => DeleteCard(car.id, car.limit, car.maxlimit);

    	$$self.$capture_state = () => ({
    		loading,
    		notify,
    		cardsDetail,
    		orderDetail,
    		fetchNui,
    		CloseCards,
    		formatCardNumber: formatCardNumber$1,
    		UpdateCard,
    		DeleteCard,
    		handleordercard,
    		formatMoney,
    		$cardsDetail
    	});

    	return [
    		$cardsDetail,
    		CloseCards,
    		UpdateCard,
    		DeleteCard,
    		handleordercard,
    		click_handler,
    		click_handler_1,
    		click_handler_2
    	];
    }

    class Cards extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance$3, create_fragment$3, safe_not_equal, {});

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "Cards",
    			options,
    			id: create_fragment$3.name
    		});
    	}
    }

    /* src\components\items.svelte generated by Svelte v3.59.2 */
    const file$2 = "src\\components\\items.svelte";

    function get_each_context(ctx, list, i) {
    	const child_ctx = ctx.slice();
    	child_ctx[4] = list[i];
    	return child_ctx;
    }

    // (30:12) {:else}
    function create_else_block(ctx) {
    	let h2;

    	const block = {
    		c: function create() {
    			h2 = element("h2");
    			h2.textContent = "No Card Found :(";
    			attr_dev(h2, "class", "svelte-iluwz0");
    			add_location(h2, file$2, 30, 16, 1312);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, h2, anchor);
    		},
    		p: noop,
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(h2);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_else_block.name,
    		type: "else",
    		source: "(30:12) {:else}",
    		ctx
    	});

    	return block;
    }

    // (19:12) {#if $itemsDetails.items.length > 0}
    function create_if_block$1(ctx) {
    	let each_1_anchor;
    	let each_value = /*$itemsDetails*/ ctx[0].items;
    	validate_each_argument(each_value);
    	let each_blocks = [];

    	for (let i = 0; i < each_value.length; i += 1) {
    		each_blocks[i] = create_each_block(get_each_context(ctx, each_value, i));
    	}

    	const block = {
    		c: function create() {
    			for (let i = 0; i < each_blocks.length; i += 1) {
    				each_blocks[i].c();
    			}

    			each_1_anchor = empty();
    		},
    		m: function mount(target, anchor) {
    			for (let i = 0; i < each_blocks.length; i += 1) {
    				if (each_blocks[i]) {
    					each_blocks[i].m(target, anchor);
    				}
    			}

    			insert_dev(target, each_1_anchor, anchor);
    		},
    		p: function update(ctx, dirty) {
    			if (dirty & /*handlecard, $itemsDetails, formatCardNumber*/ 3) {
    				each_value = /*$itemsDetails*/ ctx[0].items;
    				validate_each_argument(each_value);
    				let i;

    				for (i = 0; i < each_value.length; i += 1) {
    					const child_ctx = get_each_context(ctx, each_value, i);

    					if (each_blocks[i]) {
    						each_blocks[i].p(child_ctx, dirty);
    					} else {
    						each_blocks[i] = create_each_block(child_ctx);
    						each_blocks[i].c();
    						each_blocks[i].m(each_1_anchor.parentNode, each_1_anchor);
    					}
    				}

    				for (; i < each_blocks.length; i += 1) {
    					each_blocks[i].d(1);
    				}

    				each_blocks.length = each_value.length;
    			}
    		},
    		d: function destroy(detaching) {
    			destroy_each(each_blocks, detaching);
    			if (detaching) detach_dev(each_1_anchor);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block$1.name,
    		type: "if",
    		source: "(19:12) {#if $itemsDetails.items.length > 0}",
    		ctx
    	});

    	return block;
    }

    // (20:16) {#each $itemsDetails.items as item}
    function create_each_block(ctx) {
    	let div3;
    	let div2;
    	let div1;
    	let t0;
    	let t1_value = formatCardNumber(/*item*/ ctx[4].info.Card_number) + "";
    	let t1;
    	let t2;
    	let div0;
    	let t3;
    	let t4_value = /*item*/ ctx[4].info.name + "";
    	let t4;
    	let t5;
    	let button;
    	let t7;
    	let mounted;
    	let dispose;

    	function click_handler() {
    		return /*click_handler*/ ctx[2](/*item*/ ctx[4]);
    	}

    	const block = {
    		c: function create() {
    			div3 = element("div");
    			div2 = element("div");
    			div1 = element("div");
    			t0 = text("Card Number: ");
    			t1 = text(t1_value);
    			t2 = space();
    			div0 = element("div");
    			t3 = text("Holder: ");
    			t4 = text(t4_value);
    			t5 = space();
    			button = element("button");
    			button.textContent = "Use Card";
    			t7 = space();
    			attr_dev(div0, "class", " svelte-iluwz0");
    			add_location(div0, file$2, 23, 32, 963);
    			attr_dev(button, "type", "button");
    			attr_dev(button, "class", "btn btn-grey svelte-iluwz0");
    			add_location(button, file$2, 24, 32, 1041);
    			attr_dev(div1, "class", "btns-group2 dev svelte-iluwz0");
    			add_location(div1, file$2, 22, 28, 846);
    			attr_dev(div2, "class", "btns-group svelte-iluwz0");
    			add_location(div2, file$2, 21, 24, 792);
    			attr_dev(div3, "class", "form-row  svelte-iluwz0");
    			add_location(div3, file$2, 20, 20, 743);
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, div3, anchor);
    			append_dev(div3, div2);
    			append_dev(div2, div1);
    			append_dev(div1, t0);
    			append_dev(div1, t1);
    			append_dev(div1, t2);
    			append_dev(div1, div0);
    			append_dev(div0, t3);
    			append_dev(div0, t4);
    			append_dev(div1, t5);
    			append_dev(div1, button);
    			append_dev(div3, t7);

    			if (!mounted) {
    				dispose = listen_dev(button, "click", click_handler, false, false, false, false);
    				mounted = true;
    			}
    		},
    		p: function update(new_ctx, dirty) {
    			ctx = new_ctx;
    			if (dirty & /*$itemsDetails*/ 1 && t1_value !== (t1_value = formatCardNumber(/*item*/ ctx[4].info.Card_number) + "")) set_data_dev(t1, t1_value);
    			if (dirty & /*$itemsDetails*/ 1 && t4_value !== (t4_value = /*item*/ ctx[4].info.name + "")) set_data_dev(t4, t4_value);
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(div3);
    			mounted = false;
    			dispose();
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_each_block.name,
    		type: "each",
    		source: "(20:16) {#each $itemsDetails.items as item}",
    		ctx
    	});

    	return block;
    }

    function create_fragment$2(ctx) {
    	let section1;
    	let section0;
    	let h2;
    	let t1;

    	function select_block_type(ctx, dirty) {
    		if (/*$itemsDetails*/ ctx[0].items.length > 0) return create_if_block$1;
    		return create_else_block;
    	}

    	let current_block_type = select_block_type(ctx);
    	let if_block = current_block_type(ctx);

    	const block = {
    		c: function create() {
    			section1 = element("section");
    			section0 = element("section");
    			h2 = element("h2");
    			h2.textContent = "Available Cards";
    			t1 = space();
    			if_block.c();
    			attr_dev(h2, "class", "svelte-iluwz0");
    			add_location(h2, file$2, 17, 12, 594);
    			attr_dev(section0, "class", "popup-content scroller2 svelte-iluwz0");
    			add_location(section0, file$2, 16, 4, 539);
    			attr_dev(section1, "class", "popup-container svelte-iluwz0");
    			add_location(section1, file$2, 15, 0, 500);
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, section1, anchor);
    			append_dev(section1, section0);
    			append_dev(section0, h2);
    			append_dev(section0, t1);
    			if_block.m(section0, null);
    		},
    		p: function update(ctx, [dirty]) {
    			if (current_block_type === (current_block_type = select_block_type(ctx)) && if_block) {
    				if_block.p(ctx, dirty);
    			} else {
    				if_block.d(1);
    				if_block = current_block_type(ctx);

    				if (if_block) {
    					if_block.c();
    					if_block.m(section0, null);
    				}
    			}
    		},
    		i: noop,
    		o: noop,
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(section1);
    			if_block.d();
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment$2.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function formatCardNumber(input) {
    	var _a;

    	let formatted = ((_a = input.match(/.{1,4}/g)) === null || _a === void 0
    	? void 0
    	: _a.join(' ')) || '';

    	return formatted;
    }

    function instance$2($$self, $$props, $$invalidate) {
    	let $itemsDetails;
    	validate_store(itemsDetails, 'itemsDetails');
    	component_subscribe($$self, itemsDetails, $$value => $$invalidate(0, $itemsDetails = $$value));
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('Items', slots, []);

    	function CloseCards() {
    		itemsDetails.update(() => ({ status: false, items: [] }));
    	}

    	function handlecard(cardNumber) {
    		CloseCards();
    		pinDetails.update(() => ({ status: true, cardNumber }));
    	}

    	const writable_props = [];

    	Object.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console.warn(`<Items> was created with unknown prop '${key}'`);
    	});

    	const click_handler = item => handlecard(item.info.Card_number);

    	$$self.$capture_state = () => ({
    		itemsDetails,
    		pinDetails,
    		CloseCards,
    		formatCardNumber,
    		handlecard,
    		$itemsDetails
    	});

    	return [$itemsDetails, handlecard, click_handler];
    }

    class Items extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance$2, create_fragment$2, safe_not_equal, {});

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "Items",
    			options,
    			id: create_fragment$2.name
    		});
    	}
    }

    /* src\components\pin.svelte generated by Svelte v3.59.2 */
    const file$1 = "src\\components\\pin.svelte";

    function create_fragment$1(ctx) {
    	let section1;
    	let section0;
    	let h2;
    	let t1;
    	let form;
    	let div0;
    	let label;
    	let t3;
    	let input;
    	let t4;
    	let div1;
    	let button;
    	let mounted;
    	let dispose;

    	const block = {
    		c: function create() {
    			section1 = element("section");
    			section0 = element("section");
    			h2 = element("h2");
    			h2.textContent = "EnterPinCode";
    			t1 = space();
    			form = element("form");
    			div0 = element("div");
    			label = element("label");
    			label.textContent = "Enter pin Code";
    			t3 = space();
    			input = element("input");
    			t4 = space();
    			div1 = element("div");
    			button = element("button");
    			button.textContent = "Submit";
    			attr_dev(h2, "class", "svelte-1nt66gn");
    			add_location(h2, file$1, 10, 8, 291);
    			attr_dev(label, "for", "amount");
    			attr_dev(label, "class", "svelte-1nt66gn");
    			add_location(label, file$1, 13, 16, 393);
    			attr_dev(input, "type", "password");
    			attr_dev(input, "name", "pin");
    			attr_dev(input, "id", "pin");
    			attr_dev(input, "placeholder", "Enter Code");
    			attr_dev(input, "maxlength", "4");
    			attr_dev(input, "class", "svelte-1nt66gn");
    			add_location(input, file$1, 14, 16, 453);
    			attr_dev(div0, "class", "form-row svelte-1nt66gn");
    			add_location(div0, file$1, 12, 12, 353);
    			attr_dev(button, "type", "button");
    			attr_dev(button, "class", "btn btn-green svelte-1nt66gn");
    			add_location(button, file$1, 25, 16, 776);
    			attr_dev(div1, "class", "btns-group2 svelte-1nt66gn");
    			add_location(div1, file$1, 24, 12, 733);
    			attr_dev(form, "action", "#");
    			add_location(form, file$1, 11, 8, 322);
    			attr_dev(section0, "class", "popup-content svelte-1nt66gn");
    			add_location(section0, file$1, 9, 4, 250);
    			attr_dev(section1, "class", "popup-container svelte-1nt66gn");
    			add_location(section1, file$1, 8, 0, 211);
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, section1, anchor);
    			append_dev(section1, section0);
    			append_dev(section0, h2);
    			append_dev(section0, t1);
    			append_dev(section0, form);
    			append_dev(form, div0);
    			append_dev(div0, label);
    			append_dev(div0, t3);
    			append_dev(div0, input);
    			set_input_value(input, /*pin*/ ctx[0]);
    			append_dev(form, t4);
    			append_dev(form, div1);
    			append_dev(div1, button);

    			if (!mounted) {
    				dispose = [
    					listen_dev(input, "input", /*input_input_handler*/ ctx[1]),
    					listen_dev(button, "click", /*click_handler*/ ctx[2], false, false, false, false)
    				];

    				mounted = true;
    			}
    		},
    		p: function update(ctx, [dirty]) {
    			if (dirty & /*pin*/ 1 && input.value !== /*pin*/ ctx[0]) {
    				set_input_value(input, /*pin*/ ctx[0]);
    			}
    		},
    		i: noop,
    		o: noop,
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(section1);
    			mounted = false;
    			run_all(dispose);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment$1.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function submit() {
    	
    }

    function instance$1($$self, $$props, $$invalidate) {
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('Pin', slots, []);
    	let pin = "";

    	function CloseCards() {
    		pinDetails.update(() => ({ status: false, cardNumber: "" }));
    	}

    	const writable_props = [];

    	Object.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console.warn(`<Pin> was created with unknown prop '${key}'`);
    	});

    	function input_input_handler() {
    		pin = this.value;
    		$$invalidate(0, pin);
    	}

    	const click_handler = () => submit();
    	$$self.$capture_state = () => ({ pinDetails, pin, CloseCards, submit });

    	$$self.$inject_state = $$props => {
    		if ('pin' in $$props) $$invalidate(0, pin = $$props.pin);
    	};

    	if ($$props && "$$inject" in $$props) {
    		$$self.$inject_state($$props.$$inject);
    	}

    	return [pin, input_input_handler, click_handler];
    }

    class Pin extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance$1, create_fragment$1, safe_not_equal, {});

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "Pin",
    			options,
    			id: create_fragment$1.name
    		});
    	}
    }

    /* src\App.svelte generated by Svelte v3.59.2 */
    const file = "src\\App.svelte";

    // (24:4) {#if $accountsVisible.status}
    function create_if_block_7(ctx) {
    	let accountscontainer;
    	let current;
    	accountscontainer = new AccountsContainer({ $$inline: true });

    	const block = {
    		c: function create() {
    			create_component(accountscontainer.$$.fragment);
    		},
    		m: function mount(target, anchor) {
    			mount_component(accountscontainer, target, anchor);
    			current = true;
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(accountscontainer.$$.fragment, local);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(accountscontainer.$$.fragment, local);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			destroy_component(accountscontainer, detaching);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block_7.name,
    		type: "if",
    		source: "(24:4) {#if $accountsVisible.status}",
    		ctx
    	});

    	return block;
    }

    // (27:4) {#if $popupDetails.actionType !== ""}
    function create_if_block_6(ctx) {
    	let popup;
    	let current;
    	popup = new Popup({ $$inline: true });

    	const block = {
    		c: function create() {
    			create_component(popup.$$.fragment);
    		},
    		m: function mount(target, anchor) {
    			mount_component(popup, target, anchor);
    			current = true;
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(popup.$$.fragment, local);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(popup.$$.fragment, local);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			destroy_component(popup, detaching);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block_6.name,
    		type: "if",
    		source: "(27:4) {#if $popupDetails.actionType !== \\\"\\\"}",
    		ctx
    	});

    	return block;
    }

    // (30:4) {#if $orderDetail.status}
    function create_if_block_5(ctx) {
    	let order;
    	let current;
    	order = new Order({ $$inline: true });

    	const block = {
    		c: function create() {
    			create_component(order.$$.fragment);
    		},
    		m: function mount(target, anchor) {
    			mount_component(order, target, anchor);
    			current = true;
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(order.$$.fragment, local);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(order.$$.fragment, local);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			destroy_component(order, detaching);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block_5.name,
    		type: "if",
    		source: "(30:4) {#if $orderDetail.status}",
    		ctx
    	});

    	return block;
    }

    // (33:4) {#if $cardsDetail.status}
    function create_if_block_4(ctx) {
    	let cards;
    	let current;
    	cards = new Cards({ $$inline: true });

    	const block = {
    		c: function create() {
    			create_component(cards.$$.fragment);
    		},
    		m: function mount(target, anchor) {
    			mount_component(cards, target, anchor);
    			current = true;
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(cards.$$.fragment, local);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(cards.$$.fragment, local);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			destroy_component(cards, detaching);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block_4.name,
    		type: "if",
    		source: "(33:4) {#if $cardsDetail.status}",
    		ctx
    	});

    	return block;
    }

    // (36:4) {#if $notify !== ""}
    function create_if_block_3(ctx) {
    	let notification;
    	let current;
    	notification = new Notification({ $$inline: true });

    	const block = {
    		c: function create() {
    			create_component(notification.$$.fragment);
    		},
    		m: function mount(target, anchor) {
    			mount_component(notification, target, anchor);
    			current = true;
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(notification.$$.fragment, local);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(notification.$$.fragment, local);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			destroy_component(notification, detaching);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block_3.name,
    		type: "if",
    		source: "(36:4) {#if $notify !== \\\"\\\"}",
    		ctx
    	});

    	return block;
    }

    // (39:4) {#if $itemsDetails.status}
    function create_if_block_2(ctx) {
    	let items;
    	let current;
    	items = new Items({ $$inline: true });

    	const block = {
    		c: function create() {
    			create_component(items.$$.fragment);
    		},
    		m: function mount(target, anchor) {
    			mount_component(items, target, anchor);
    			current = true;
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(items.$$.fragment, local);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(items.$$.fragment, local);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			destroy_component(items, detaching);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block_2.name,
    		type: "if",
    		source: "(39:4) {#if $itemsDetails.status}",
    		ctx
    	});

    	return block;
    }

    // (42:4) {#if $pinDetails.status}
    function create_if_block_1(ctx) {
    	let pin;
    	let current;
    	pin = new Pin({ $$inline: true });

    	const block = {
    		c: function create() {
    			create_component(pin.$$.fragment);
    		},
    		m: function mount(target, anchor) {
    			mount_component(pin, target, anchor);
    			current = true;
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(pin.$$.fragment, local);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(pin.$$.fragment, local);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			destroy_component(pin, detaching);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block_1.name,
    		type: "if",
    		source: "(42:4) {#if $pinDetails.status}",
    		ctx
    	});

    	return block;
    }

    // (23:0) <VisibilityProvider>
    function create_default_slot(ctx) {
    	let t0;
    	let t1;
    	let t2;
    	let t3;
    	let t4;
    	let t5;
    	let if_block6_anchor;
    	let current;
    	let if_block0 = /*$accountsVisible*/ ctx[0].status && create_if_block_7(ctx);
    	let if_block1 = /*$popupDetails*/ ctx[1].actionType !== "" && create_if_block_6(ctx);
    	let if_block2 = /*$orderDetail*/ ctx[2].status && create_if_block_5(ctx);
    	let if_block3 = /*$cardsDetail*/ ctx[3].status && create_if_block_4(ctx);
    	let if_block4 = /*$notify*/ ctx[4] !== "" && create_if_block_3(ctx);
    	let if_block5 = /*$itemsDetails*/ ctx[5].status && create_if_block_2(ctx);
    	let if_block6 = /*$pinDetails*/ ctx[6].status && create_if_block_1(ctx);

    	const block = {
    		c: function create() {
    			if (if_block0) if_block0.c();
    			t0 = space();
    			if (if_block1) if_block1.c();
    			t1 = space();
    			if (if_block2) if_block2.c();
    			t2 = space();
    			if (if_block3) if_block3.c();
    			t3 = space();
    			if (if_block4) if_block4.c();
    			t4 = space();
    			if (if_block5) if_block5.c();
    			t5 = space();
    			if (if_block6) if_block6.c();
    			if_block6_anchor = empty();
    		},
    		m: function mount(target, anchor) {
    			if (if_block0) if_block0.m(target, anchor);
    			insert_dev(target, t0, anchor);
    			if (if_block1) if_block1.m(target, anchor);
    			insert_dev(target, t1, anchor);
    			if (if_block2) if_block2.m(target, anchor);
    			insert_dev(target, t2, anchor);
    			if (if_block3) if_block3.m(target, anchor);
    			insert_dev(target, t3, anchor);
    			if (if_block4) if_block4.m(target, anchor);
    			insert_dev(target, t4, anchor);
    			if (if_block5) if_block5.m(target, anchor);
    			insert_dev(target, t5, anchor);
    			if (if_block6) if_block6.m(target, anchor);
    			insert_dev(target, if_block6_anchor, anchor);
    			current = true;
    		},
    		p: function update(ctx, dirty) {
    			if (/*$accountsVisible*/ ctx[0].status) {
    				if (if_block0) {
    					if (dirty & /*$accountsVisible*/ 1) {
    						transition_in(if_block0, 1);
    					}
    				} else {
    					if_block0 = create_if_block_7(ctx);
    					if_block0.c();
    					transition_in(if_block0, 1);
    					if_block0.m(t0.parentNode, t0);
    				}
    			} else if (if_block0) {
    				group_outros();

    				transition_out(if_block0, 1, 1, () => {
    					if_block0 = null;
    				});

    				check_outros();
    			}

    			if (/*$popupDetails*/ ctx[1].actionType !== "") {
    				if (if_block1) {
    					if (dirty & /*$popupDetails*/ 2) {
    						transition_in(if_block1, 1);
    					}
    				} else {
    					if_block1 = create_if_block_6(ctx);
    					if_block1.c();
    					transition_in(if_block1, 1);
    					if_block1.m(t1.parentNode, t1);
    				}
    			} else if (if_block1) {
    				group_outros();

    				transition_out(if_block1, 1, 1, () => {
    					if_block1 = null;
    				});

    				check_outros();
    			}

    			if (/*$orderDetail*/ ctx[2].status) {
    				if (if_block2) {
    					if (dirty & /*$orderDetail*/ 4) {
    						transition_in(if_block2, 1);
    					}
    				} else {
    					if_block2 = create_if_block_5(ctx);
    					if_block2.c();
    					transition_in(if_block2, 1);
    					if_block2.m(t2.parentNode, t2);
    				}
    			} else if (if_block2) {
    				group_outros();

    				transition_out(if_block2, 1, 1, () => {
    					if_block2 = null;
    				});

    				check_outros();
    			}

    			if (/*$cardsDetail*/ ctx[3].status) {
    				if (if_block3) {
    					if (dirty & /*$cardsDetail*/ 8) {
    						transition_in(if_block3, 1);
    					}
    				} else {
    					if_block3 = create_if_block_4(ctx);
    					if_block3.c();
    					transition_in(if_block3, 1);
    					if_block3.m(t3.parentNode, t3);
    				}
    			} else if (if_block3) {
    				group_outros();

    				transition_out(if_block3, 1, 1, () => {
    					if_block3 = null;
    				});

    				check_outros();
    			}

    			if (/*$notify*/ ctx[4] !== "") {
    				if (if_block4) {
    					if (dirty & /*$notify*/ 16) {
    						transition_in(if_block4, 1);
    					}
    				} else {
    					if_block4 = create_if_block_3(ctx);
    					if_block4.c();
    					transition_in(if_block4, 1);
    					if_block4.m(t4.parentNode, t4);
    				}
    			} else if (if_block4) {
    				group_outros();

    				transition_out(if_block4, 1, 1, () => {
    					if_block4 = null;
    				});

    				check_outros();
    			}

    			if (/*$itemsDetails*/ ctx[5].status) {
    				if (if_block5) {
    					if (dirty & /*$itemsDetails*/ 32) {
    						transition_in(if_block5, 1);
    					}
    				} else {
    					if_block5 = create_if_block_2(ctx);
    					if_block5.c();
    					transition_in(if_block5, 1);
    					if_block5.m(t5.parentNode, t5);
    				}
    			} else if (if_block5) {
    				group_outros();

    				transition_out(if_block5, 1, 1, () => {
    					if_block5 = null;
    				});

    				check_outros();
    			}

    			if (/*$pinDetails*/ ctx[6].status) {
    				if (if_block6) {
    					if (dirty & /*$pinDetails*/ 64) {
    						transition_in(if_block6, 1);
    					}
    				} else {
    					if_block6 = create_if_block_1(ctx);
    					if_block6.c();
    					transition_in(if_block6, 1);
    					if_block6.m(if_block6_anchor.parentNode, if_block6_anchor);
    				}
    			} else if (if_block6) {
    				group_outros();

    				transition_out(if_block6, 1, 1, () => {
    					if_block6 = null;
    				});

    				check_outros();
    			}
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(if_block0);
    			transition_in(if_block1);
    			transition_in(if_block2);
    			transition_in(if_block3);
    			transition_in(if_block4);
    			transition_in(if_block5);
    			transition_in(if_block6);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(if_block0);
    			transition_out(if_block1);
    			transition_out(if_block2);
    			transition_out(if_block3);
    			transition_out(if_block4);
    			transition_out(if_block5);
    			transition_out(if_block6);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			if (if_block0) if_block0.d(detaching);
    			if (detaching) detach_dev(t0);
    			if (if_block1) if_block1.d(detaching);
    			if (detaching) detach_dev(t1);
    			if (if_block2) if_block2.d(detaching);
    			if (detaching) detach_dev(t2);
    			if (if_block3) if_block3.d(detaching);
    			if (detaching) detach_dev(t3);
    			if (if_block4) if_block4.d(detaching);
    			if (detaching) detach_dev(t4);
    			if (if_block5) if_block5.d(detaching);
    			if (detaching) detach_dev(t5);
    			if (if_block6) if_block6.d(detaching);
    			if (detaching) detach_dev(if_block6_anchor);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_default_slot.name,
    		type: "slot",
    		source: "(23:0) <VisibilityProvider>",
    		ctx
    	});

    	return block;
    }

    // (46:0) {#if $loading}
    function create_if_block(ctx) {
    	let loading_1;
    	let current;
    	loading_1 = new Loading({ $$inline: true });

    	const block = {
    		c: function create() {
    			create_component(loading_1.$$.fragment);
    		},
    		m: function mount(target, anchor) {
    			mount_component(loading_1, target, anchor);
    			current = true;
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(loading_1.$$.fragment, local);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(loading_1.$$.fragment, local);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			destroy_component(loading_1, detaching);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_if_block.name,
    		type: "if",
    		source: "(46:0) {#if $loading}",
    		ctx
    	});

    	return block;
    }

    function create_fragment(ctx) {
    	let link;
    	let t0;
    	let visibilityprovider;
    	let t1;
    	let if_block_anchor;
    	let current;

    	visibilityprovider = new VisibilityProvider({
    			props: {
    				$$slots: { default: [create_default_slot] },
    				$$scope: { ctx }
    			},
    			$$inline: true
    		});

    	let if_block = /*$loading*/ ctx[7] && create_if_block(ctx);

    	const block = {
    		c: function create() {
    			link = element("link");
    			t0 = space();
    			create_component(visibilityprovider.$$.fragment);
    			t1 = space();
    			if (if_block) if_block.c();
    			if_block_anchor = empty();
    			attr_dev(link, "rel", "stylesheet");
    			attr_dev(link, "href", "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css");
    			attr_dev(link, "integrity", "sha512-1sCRPdkRXhBV2PBLUdRb4tMg1w2YPf37qatUFeS7zlBy7jJI8Lf4VHwWfZZfpXtYSLy85pkm9GaYVYMfw5BC1A==");
    			attr_dev(link, "crossorigin", "anonymous");
    			attr_dev(link, "referrerpolicy", "no-referrer");
    			add_location(link, file, 20, 4, 809);
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			append_dev(document.head, link);
    			insert_dev(target, t0, anchor);
    			mount_component(visibilityprovider, target, anchor);
    			insert_dev(target, t1, anchor);
    			if (if_block) if_block.m(target, anchor);
    			insert_dev(target, if_block_anchor, anchor);
    			current = true;
    		},
    		p: function update(ctx, [dirty]) {
    			const visibilityprovider_changes = {};

    			if (dirty & /*$$scope, $pinDetails, $itemsDetails, $notify, $cardsDetail, $orderDetail, $popupDetails, $accountsVisible*/ 383) {
    				visibilityprovider_changes.$$scope = { dirty, ctx };
    			}

    			visibilityprovider.$set(visibilityprovider_changes);

    			if (/*$loading*/ ctx[7]) {
    				if (if_block) {
    					if (dirty & /*$loading*/ 128) {
    						transition_in(if_block, 1);
    					}
    				} else {
    					if_block = create_if_block(ctx);
    					if_block.c();
    					transition_in(if_block, 1);
    					if_block.m(if_block_anchor.parentNode, if_block_anchor);
    				}
    			} else if (if_block) {
    				group_outros();

    				transition_out(if_block, 1, 1, () => {
    					if_block = null;
    				});

    				check_outros();
    			}
    		},
    		i: function intro(local) {
    			if (current) return;
    			transition_in(visibilityprovider.$$.fragment, local);
    			transition_in(if_block);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(visibilityprovider.$$.fragment, local);
    			transition_out(if_block);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			detach_dev(link);
    			if (detaching) detach_dev(t0);
    			destroy_component(visibilityprovider, detaching);
    			if (detaching) detach_dev(t1);
    			if (if_block) if_block.d(detaching);
    			if (detaching) detach_dev(if_block_anchor);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function instance($$self, $$props, $$invalidate) {
    	let $accountsVisible;
    	let $popupDetails;
    	let $orderDetail;
    	let $cardsDetail;
    	let $notify;
    	let $itemsDetails;
    	let $pinDetails;
    	let $loading;
    	validate_store(accountsVisible, 'accountsVisible');
    	component_subscribe($$self, accountsVisible, $$value => $$invalidate(0, $accountsVisible = $$value));
    	validate_store(popupDetails, 'popupDetails');
    	component_subscribe($$self, popupDetails, $$value => $$invalidate(1, $popupDetails = $$value));
    	validate_store(orderDetail, 'orderDetail');
    	component_subscribe($$self, orderDetail, $$value => $$invalidate(2, $orderDetail = $$value));
    	validate_store(cardsDetail, 'cardsDetail');
    	component_subscribe($$self, cardsDetail, $$value => $$invalidate(3, $cardsDetail = $$value));
    	validate_store(notify, 'notify');
    	component_subscribe($$self, notify, $$value => $$invalidate(4, $notify = $$value));
    	validate_store(itemsDetails, 'itemsDetails');
    	component_subscribe($$self, itemsDetails, $$value => $$invalidate(5, $itemsDetails = $$value));
    	validate_store(pinDetails, 'pinDetails');
    	component_subscribe($$self, pinDetails, $$value => $$invalidate(6, $pinDetails = $$value));
    	validate_store(loading, 'loading');
    	component_subscribe($$self, loading, $$value => $$invalidate(7, $loading = $$value));
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('App', slots, []);
    	debugData([{ action: "setVisible", data: true }]);
    	const writable_props = [];

    	Object.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console.warn(`<App> was created with unknown prop '${key}'`);
    	});

    	$$self.$capture_state = () => ({
    		VisibilityProvider,
    		debugData,
    		AccountsContainer,
    		Popup,
    		Loading,
    		Notification,
    		popupDetails,
    		loading,
    		notify,
    		orderDetail,
    		cardsDetail,
    		accountsVisible,
    		itemsDetails,
    		pinDetails,
    		Order,
    		Cards,
    		Items,
    		Pin,
    		$accountsVisible,
    		$popupDetails,
    		$orderDetail,
    		$cardsDetail,
    		$notify,
    		$itemsDetails,
    		$pinDetails,
    		$loading
    	});

    	return [
    		$accountsVisible,
    		$popupDetails,
    		$orderDetail,
    		$cardsDetail,
    		$notify,
    		$itemsDetails,
    		$pinDetails,
    		$loading
    	];
    }

    class App extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance, create_fragment, safe_not_equal, {});

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "App",
    			options,
    			id: create_fragment.name
    		});
    	}
    }

    const app = new App({
        target: document.body,
    });

    return app;

})();
//# sourceMappingURL=bundle.js.map
