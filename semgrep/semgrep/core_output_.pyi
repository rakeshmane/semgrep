"""
This file encapsulates classes necessary in parsing semgrep-core json output into a typed object

The objects in this class should expose functionality that returns objects that the rest of the codebase
interacts with (e.g. the rest of the codebase should be interacting with RuleMatch objects instead of CoreMatch
and SemgrepCoreError instead of CoreError objects).

The precise type of the response from semgrep-core is specified in
Semgrep_core_response.atd, currently at:
https://github.com/returntocorp/semgrep/blob/develop/semgrep-core/src/core-response/Semgrep_core_response.atd
"""

from typing import Any, Dict, List, Sequence, Set, Tuple, Optional, Collection
import attr
import semgrep.types as types

@attr.s(auto_attribs=True)
class CoreOutput:
    """
    Parses output of semgrep-core
    """

    @classmethod
    def parse(cls, raw_json: types.JsonObject, rule_id: types.RuleId) -> "CoreOutput":
        ...