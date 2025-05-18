//
//  LeakCheckMacro.swift
//  LeakCheck
//
//  Created by Gabriel Radu on 17.04.25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct TrackedInstancesMacro: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf decl: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        #if DEBUG
        guard let classDecl = decl.as(ClassDeclSyntax.self) else {
            throw MacroExpansionErrorMessage("@TrackedInstances can only be applied to classes")
        }
        let className = classDecl.name.text

        let property: String
        if
            let args = node.arguments?.as(LabeledExprListSyntax.self),
            args.count > 0
        {
            
            guard
                args.count == 1,
                let arg = args.first,
                arg.label?.text == "tag",
                let argExpr = arg.expression.as(StringLiteralExprSyntax.self),
                let argExprSeg = argExpr.segments.first?.as(StringSegmentSyntax.self)
            else {
                throw MacroExpansionErrorMessage(
                    "@TrackedInstances can only accept one optional parameter named 'tag'"
                )
            }
            let tagString = argExprSeg.content.text
            property = """
            let __leakCheckInstanceTrackerProperty = LeakCheck.TrackerStruct(type: \(className).self, tag: "\(tagString)")
            """
        } else {
            property = """
            let __leakCheckInstanceTrackerProperty = LeakCheck.TrackerStruct(type: \(className).self)
            """
        }

        return [DeclSyntax(stringLiteral: property)]
        #else
        return []
        #endif
        
    }
}

@main
struct LeakCheckPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        TrackedInstancesMacro.self,
    ]
}
