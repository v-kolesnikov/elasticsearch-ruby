# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module API
    module Indices
      module Actions

        # Create or update an index warmer.
        #
        # An index warmer will run before an index is refreshed, ie. available for search.
        # It allows you to register "heavy" queries with popular filters, facets or sorts,
        # increasing performance when the index is searched for the first time.
        #
        # @example Register a warmer which will populate the caches for `published` filter and sorting on `created_at`
        #
        #     client.indices.put_warmer index: 'myindex',
        #                               name: 'main',
        #                               body: {
        #                                 query: { filtered: { filter: { term: { published: true } } } },
        #                                 sort:  [ "created_at" ]
        #                               }
        #
        # @option arguments [List] :index A comma-separated list of index names to register the warmer for; use `_all`
        #                                 or empty string to perform the operation on all indices (*Required*)
        # @option arguments [String] :name The name of the warmer (*Required*)
        # @option arguments [List] :type A comma-separated list of document types to register the warmer for;
        #                                leave empty to perform the operation on all types
        # @option arguments [Hash] :body The search request definition for the warmer
        #                                (query, filters, facets, sorting, etc) (*Required*)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into
        #                                               no concrete indices. (This includes `_all` string or when no
        #                                               indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that
        #                                              are open, closed or both. (options: open, closed)
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore
        #                                            `missing` ones (options: none, missing) @until 1.0
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when
        #                                                 unavailable (missing, closed, etc)
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-warmers/
        #
        def put_warmer(arguments={})
          raise ArgumentError, "Required argument 'name' missing"  unless arguments[:name]
          raise ArgumentError, "Required argument 'body' missing"  unless arguments[:body]
          method = HTTP_PUT
          path   = Utils.__pathify( Utils.__listify(arguments[:index]),
                                    Utils.__listify(arguments[:type]),
                                    '_warmer',
                                    Utils.__listify(arguments[:name]) )
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:put_warmer, [
            :ignore_indices,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards ].freeze)
      end
    end
  end
end
